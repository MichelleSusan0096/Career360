#!/usr/bin/env python3
"""
Career360 frontend verification hook.

Runs frontend checks only when frontend files are changed. It intentionally
uses npm scripts from frontend/package.json rather than assuming a specific
package manager or inventing commands.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
FRONTEND = ROOT / "frontend"


def changed_files() -> list[str]:
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

    files: list[str] = []
    for line in proc.stdout.splitlines():
        if len(line) >= 4:
            files.append(line[3:].strip().strip('"').replace("\\", "/"))
    return files


def run(cmd: list[str]) -> int:
    print(f"[ui_verify] $ {' '.join(cmd)}")
    try:
        return subprocess.run(cmd, cwd=FRONTEND, timeout=180).returncode
    except FileNotFoundError:
        print(f"[ui_verify] SKIP: {cmd[0]} not available.")
        return 0
    except subprocess.TimeoutExpired:
        print("[ui_verify] FAIL: command timed out.")
        return 124


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--changed", action="store_true")
    args = parser.parse_args()

    package_json = FRONTEND / "package.json"
    if not package_json.exists():
        print("[ui_verify] frontend/package.json not found; UI checks skipped.")
        return 0

    if args.changed:
        changed = changed_files()
        if changed and not any(p.startswith("frontend/") for p in changed):
            print("[ui_verify] No frontend changes detected; PASS.")
            return 0

    try:
        package = json.loads(package_json.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"[ui_verify] FAIL: invalid package.json ({exc})")
        return 1

    scripts = package.get("scripts", {})
    preferred = ["lint", "typecheck"]
    commands: list[list[str]] = []

    for script in preferred:
        if script in scripts:
            commands.append(["npm", "run", script])

    # A TypeScript Vite project may not have a dedicated typecheck script yet.
    # In that case, do not pretend one exists; the general build remains the
    # strongest available deterministic check.
    if "typecheck" not in scripts and "build" in scripts:
        commands.append(["npm", "run", "build"])

    for command in commands:
        code = run(command)
        if code != 0:
            return code

    print("[ui_verify] PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
