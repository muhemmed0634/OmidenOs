# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
"""Unit test: brand-scan finds hits and fails with a non-zero exit."""

import subprocess
import tempfile
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SCANNER = REPO_ROOT / "scripts" / "brand-scan"


class BrandScanCliTests(unittest.TestCase):
    def run_scan(self, text: str, tmpdir: Path):
        (tmpdir / "sample.txt").write_text(text, encoding="utf-8")
        return subprocess.run(
            [str(SCANNER), "--mode", "strict", "--path", str(tmpdir)],
            capture_output=True,
            text=True,
        )

    def test_hit_fails(self):
        with tempfile.TemporaryDirectory() as td:
            proc = self.run_scan("welcome to Arch Linux\n", Path(td))
            self.assertEqual(proc.returncode, 1)
            self.assertIn("[arch-linux]", proc.stdout)

    def test_clean_passes(self):
        with tempfile.TemporaryDirectory() as td:
            proc = self.run_scan("OmidenOS live medium\n", Path(td))
            self.assertEqual(proc.returncode, 0)
            self.assertIn("OK", proc.stdout)

    def test_scan_scope_outside_repo_still_applies_allowlist_semantics(self):
        # Files outside archiso/ are not allowlisted, so a stock hook
        # name there must fail regardless of allowlist entries.
        with tempfile.TemporaryDirectory() as td:
            proc = self.run_scan("hooks: archiso\n", Path(td))
            self.assertEqual(proc.returncode, 1)
            self.assertIn("[archiso]", proc.stdout)


if __name__ == "__main__":
    unittest.main()
