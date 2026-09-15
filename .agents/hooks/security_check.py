#!/usr/bin/env python3
"""
Career360 lightweight repository security hook.

Scans changed text/configuration files for common accidental secret patterns
and dangerous local-development shortcuts. This is not a replacement for a
full SAST/secrets scanner.
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]

IGNORED_PARTS = {
    ".git",
    "node_modules",
    "target",
    "dist",
    "build",
    ".venv",
    "__pycache__",
}

SECRET_PATTERNS = [
    re.compile(r"(?i)\b(api[_-]?key|secret|password|passwd|token)\b\s*[:=]\s*['\"][^'\"]{8,}['\"]"),
    re.compile(r"\bsk-[A-Za-z0-9_-]{20,}\b"),
    re.compile(r"\bAIza[0-9A-Za-z_-]{20,}\b"),
    re.compile(r"(?i)\bAKIA[0-9A-Z]{16}\b"),
    re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----"),
    re.compile(r"(?i)jdbc:[^\s'\"]+password=[^\s'\"]+"),
]

DANGEROUS_PATTERNS = [
    (re.compile(r"(?i)\bpermitAll\s*\("), "permitAll() found; confirm this endpoint is intentionally public."),
    (re.compile(r"(?i)Access-Control-Allow-Origin[^\\n]*\*"), "Wildcard CORS detected."),
    (re.compile(r"(?i)\bdebug\s*[:=]\s*true\b"), "debug=true detected in a changed file."),
]


def changed_files() -> list[Path]:
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

    results: list[Path] = []
    for line in proc.stdout.splitlines():
        if len(line) < 4:
            continue
        payload = line[3:]
        if " -> " in payload:
            payload = payload.split(" -> ", 1)[-1]
        raw = payload.strip().strip('"')
        p = (ROOT / raw).resolve()
        try:
            p.relative_to(ROOT.resolve())
        except ValueError:
            continue
        results.append(p)
    return results


def should_scan(path: Path) -> bool:
    if not path.is_file():
        return False
    try:
        rel = path.relative_to(ROOT)
    except ValueError:
        return False
    if any(part in IGNORED_PARTS for part in rel.parts):
        return False
    # Scan source/config/docs text but avoid large/binary files.
    text_extensions = {
        ".java", ".kt", ".ts", ".tsx", ".js", ".jsx", ".json", ".yml", ".yaml",
        ".properties", ".xml", ".md", ".sql", ".py", ".sh", ".html", ".css",
        ".scss", ".env", ".txt",
    }
    return path.suffix.lower() in text_extensions or path.name.startswith(".env")


def scan_file(path: Path) -> list[str]:
    try:
        data = path.read_text(encoding="utf-8", errors="ignore")
    except OSError as exc:
        return [f"{path.relative_to(ROOT)}: unable to read ({exc})"]

    findings: list[str] = []
    for number, line in enumerate(data.splitlines(), start=1):
        for pattern in SECRET_PATTERNS:
            if pattern.search(line):
                findings.append(
                    f"{path.relative_to(ROOT)}:{number}: possible secret/credential pattern"
                )
                break

        for pattern, message in DANGEROUS_PATTERNS:
            if pattern.search(line):
                findings.append(f"{path.relative_to(ROOT)}:{number}: {message}")

    return findings


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--changed", action="store_true")
    args = parser.parse_args()

    paths = changed_files() if args.changed else [
        p for p in ROOT.rglob("*") if should_scan(p)
    ]

    findings: list[str] = []
    for path in paths:
        if should_scan(path):
            findings.extend(scan_file(path))

    if findings:
        print("[security] FAIL")
        for item in findings:
            print(f"  - {item}")
        print("[security] Review findings and remove real secrets before continuing.")
        return 1

    print("[security] PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
