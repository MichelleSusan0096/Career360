#!/usr/bin/env python3
"""
Career360 PostToolUse verification hook.

Usage:
    python .agents/hooks/verify.py --changed
    python .agents/hooks/verify.py --full

The hook is intentionally dependency-light and uses only the Python standard
library plus commands already expected in the Career360 repository.
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def run(cmd: list[str], cwd: Path = ROOT, timeout: int = 180) -> int:
    print(f"[verify] $ {' '.join(cmd)}")
    try:
        proc = subprocess.run(cmd, cwd=cwd, timeout=timeout)
    except FileNotFoundError:
        print(f"[verify] SKIP: command not found: {cmd[0]}")
        return 0
    except subprocess.TimeoutExpired:
        print(f"[verify] FAIL: timed out after {timeout}s")
        return 124
    return proc.returncode


def git_changed_files() -> list[str]:
    try:
        proc = subprocess.run(
            ["git", "status", "--porcelain", "--untracked-files=all"],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=True,
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        return []

    changed: list[str] = []
    for line in proc.stdout.splitlines():
        if len(line) < 4:
            continue
        # Handles ordinary status and rename status conservatively.
        payload = line[3:]
        if " -> " in payload:
            payload = payload.split(" -> ", 1)[-1]
        changed.append(payload.strip().strip('"'))
    return changed


def has_any(changed: list[str], prefixes: tuple[str, ...]) -> bool:
    return any(path.replace("\\", "/").startswith(prefixes) for path in changed)


def verify_frontend(full: bool) -> int:
    package_json = ROOT / "frontend" / "package.json"
    if not package_json.exists():
        print("[verify] frontend not initialized; frontend checks skipped.")
        return 0

    commands: list[list[str]] = []

    if full:
        commands += [
            ["npm", "run", "lint"],
            ["npm", "run", "typecheck"],
            ["npm", "run", "test"],
            ["npm", "run", "build"],
        ]
    else:
        commands += [
            ["npm", "run", "lint"],
            ["npm", "run", "typecheck"],
        ]

    for cmd in commands:
        code = run(cmd, cwd=package_json.parent)
        if code != 0:
            return code
    return 0


def verify_backend(full: bool) -> int:
    backend = ROOT / "backend"
    if not backend.exists():
        print("[verify] backend not initialized; backend checks skipped.")
        return 0

    if (backend / "mvnw").exists():
        wrapper = "./mvnw"
    elif (backend / "mvnw.cmd").exists() and os.name == "nt":
        wrapper = "mvnw.cmd"
    else:
        wrapper = "mvn"

    commands = [[wrapper, "-q", "-DskipTests", "compile"]]
    if full:
        commands.append([wrapper, "-q", "test"])

    for cmd in commands:
        code = run(cmd, cwd=backend)
        if code != 0:
            return code
    return 0


def verify_database(full: bool) -> int:
    db = ROOT / "db"
    if not db.exists():
        print("[verify] db directory not initialized; database checks skipped.")
        return 0

    migrations = db / "migrations"
    if migrations.exists():
        files = sorted(migrations.rglob("*.sql"))
        print(f"[verify] migration files discovered: {len(files)}")
        names = [f.name for f in files]
        if len(names) != len(set(names)):
            print("[verify] FAIL: duplicate migration filenames detected.")
            return 1

    # Flyway/DB integration execution belongs to project configuration.
    # This hook validates repository-level migration hygiene without inventing
    # connection credentials or environments.
    return 0


def verify_repository() -> int:
    required = [
        ROOT / "AGENTS.md",
        ROOT / ".antigravityignore",
        ROOT / "docs",
        ROOT / ".agents" / "rules",
        ROOT / ".agents" / "agents",
        ROOT / ".agents" / "skills",
    ]
    for path in required:
        if not path.exists():
            print(f"[verify] FAIL: required project path missing: {path}")
            return 1
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--changed", action="store_true")
    parser.add_argument("--full", action="store_true")
    args = parser.parse_args()

    full = args.full and not args.changed
    changed = git_changed_files()

    if not changed and args.changed:
        print("[verify] No Git changes detected; repository-level verification only.")
        return verify_repository()

    code = verify_repository()
    if code:
        return code

    frontend_changed = full or has_any(changed, ("frontend/",))
    backend_changed = full or has_any(changed, ("backend/",))
    db_changed = full or has_any(changed, ("db/", "backend/src/main/resources/db/"))

    if frontend_changed:
        code = verify_frontend(full)
        if code:
            return code

    if backend_changed:
        code = verify_backend(full)
        if code:
            return code

    if db_changed:
        code = verify_database(full)
        if code:
            return code

    print("[verify] PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
