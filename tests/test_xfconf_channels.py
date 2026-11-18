# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
"""Every xfconf channel the customize step writes must be valid XML.

A malformed channel file is not an error at build time: xfconf ignores it and
the session silently starts with defaults, which is exactly the class of bug
that is expensive to find on a booted medium. The XML lives inside the
heredocs of `customize_airootfs.sh`, so it is extracted from there and parsed
here, without building an ISO.
"""

from __future__ import annotations

import pathlib
import re
import unittest
from xml.etree import ElementTree

SCRIPT = (
    pathlib.Path(__file__).resolve().parent.parent
    / "archiso/airootfs/root/customize_airootfs.sh"
)

HEREDOC = re.compile(r"cat >(\S+) <<'EOF'\n(.*?)\nEOF\n", re.DOTALL)


def channel_blocks() -> list[tuple[str, str]]:
    text = SCRIPT.read_text(encoding="utf-8")
    return [
        (target, body)
        for target, body in HEREDOC.findall(text)
        if "<?xml" in body
    ]


class XfconfChannelTests(unittest.TestCase):
    def test_the_script_writes_at_least_the_expected_channels(self) -> None:
        targets = {target.rsplit("/", 1)[-1] for target, _ in channel_blocks()}
        for expected in (
            "xfce4-panel.xml",
            "xfwm4.xml",
            "xfce4-desktop.xml",
            "xsettings.xml",
            "xfce4-keyboard-shortcuts.xml",
            "thunar.xml",
            "xfce4-notifyd.xml",
        ):
            self.assertIn(expected, targets)

    def test_every_channel_file_is_well_formed_xml(self) -> None:
        for target, body in channel_blocks():
            with self.subTest(target=target):
                ElementTree.fromstring(body)

    def test_the_channel_name_matches_the_file_name(self) -> None:
        for target, body in channel_blocks():
            with self.subTest(target=target):
                root = ElementTree.fromstring(body)
                self.assertEqual(root.tag, "channel")
                self.assertEqual(root.get("name"), target.rsplit("/", 1)[-1][: -len(".xml")])

    def test_panel_plugin_ids_have_a_definition_each(self) -> None:
        body = dict(channel_blocks())["/home/omiden/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"]
        root = ElementTree.fromstring(body)
        ids = [
            value.get("value", "")
            for value in root.findall("./property[@name='panels']//property[@name='plugin-ids']/value")
        ]
        defined = [
            prop.get("name", "").replace("plugin-", "")
            for prop in root.findall("./property[@name='plugins']/property")
        ]
        self.assertEqual(sorted(ids), sorted(defined))


if __name__ == "__main__":
    unittest.main()
