# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
"""Unit tests for the brand scan term configuration and scanner logic."""

import importlib.machinery
import importlib.util
import unittest
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parent.parent


class ForbiddenTermTests(unittest.TestCase):
    bs: Any

    def setUp(self) -> None:
        spec = importlib.util.spec_from_loader(
            "brand_scan", importlib.machinery.SourceFileLoader(
                "brand_scan", str(REPO_ROOT / "scripts" / "brand-scan")
            )
        )
        assert spec is not None and spec.loader is not None
        self.bs = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(self.bs)
        cfg = self.bs.load_toml(
            REPO_ROOT / "branding" / "forbidden-terms.toml"
        )
        self.patterns = self.bs.compile_patterns(cfg["forbidden"])

    def match(self, text: str) -> bool:
        return any(p.search(text) for _, p in self.patterns)

    def test_forbidden_terms_hit(self) -> None:
        for sample in (
            "archlinux",
            "Arch Linux",
            "arch_linux",
            "archiso",
            "archinstall",
            "arch-chroot",
            "blackarch",
            "the AUR helper",
            "linux-7.3.4-arch1-2",
            "archisobasedir=/omidenos",
        ):
            with self.subTest(sample=sample):
                self.assertTrue(self.match(sample), sample)

    def test_generic_arch_words_do_not_hit(self) -> None:
        for sample in (
            "the search path",
            "research paper",
            "the system architecture",
            "hierarchy of nodes",
            'if [ "$grub_platform" = "efi" ]; then',
            "Architecture = auto",
            "arch=$(uname -m)",
        ):
            with self.subTest(sample=sample):
                self.assertFalse(self.match(sample), sample)

    def test_allowlist_matches_profile_paths_only(self) -> None:
        allow = self.bs.load_toml(
            REPO_ROOT / "branding" / "upstream-allowlist.toml"
        )["allowlist"]
        reason = self.bs.allowlist_reason(
            REPO_ROOT / "archiso" / "efiboot" / "loader" / "loader.conf",
            "archiso",
            allow,
        )
        self.assertTrue(reason and "Interim" in reason)
        reason_docs = self.bs.allowlist_reason(
            REPO_ROOT / "ctl" / "main.py", "archiso", allow
        )
        self.assertIsNone(reason_docs)


if __name__ == "__main__":
    unittest.main()
