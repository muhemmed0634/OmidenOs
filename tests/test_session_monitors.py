# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
"""Tests for the connector discovery in omidenos-session.

xfdesktop keys its backdrop on the monitor connector name
(/backdrop/screen0/monitor<connector>/workspace<n>/last-image), so the
session helper has to know those names. It reads them from /sys/class/drm;
these tests drive that lookup through OMIDENOS_DRM_ROOT with a fixture tree.
"""

from __future__ import annotations

import os
import pathlib
import subprocess
import tempfile
import unittest

SCRIPT = (
    pathlib.Path(__file__).resolve().parent.parent
    / "archiso/airootfs/usr/local/bin/omidenos-session"
)


def run_outputs(drm_root: pathlib.Path) -> subprocess.CompletedProcess[str]:
    env = dict(os.environ, OMIDENOS_DRM_ROOT=str(drm_root))
    return subprocess.run(
        [str(SCRIPT), "--print-outputs"],
        capture_output=True,
        text=True,
        env=env,
        check=False,
    )


class MonitorOutputTests(unittest.TestCase):
    def test_only_connected_connectors_are_reported(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            for name, status in {
                "card0-Virtual-1": "connected",
                "card0-DP-1": "connected",
                "card0-HDMI-A-1": "disconnected",
                "card0-DP-2": "unknown",
            }.items():
                entry = root / name
                entry.mkdir()
                (entry / "status").write_text(status + "\n", encoding="utf-8")

            result = run_outputs(root)

            self.assertEqual(result.returncode, 0, result.stderr)
            # glob order: DP-1, DP-2, HDMI-A-1, Virtual-1
            self.assertEqual(result.stdout.split(), ["DP-1", "Virtual-1"])

    def test_an_empty_drm_root_is_not_an_error(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            result = run_outputs(pathlib.Path(tmp))
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(result.stdout.strip(), "")

    def test_the_script_stays_posix_sh(self) -> None:
        first_line = SCRIPT.read_text(encoding="utf-8").splitlines()[0]
        self.assertEqual(first_line, "#!/bin/sh")


if __name__ == "__main__":
    unittest.main()
