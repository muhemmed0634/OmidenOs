# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
#
# Licensing note: the root LICENSE is BSD 3-Clause (owner's file).
# Alignment with the project spec (GPL-3.0-or-later) is tracked in
# docs/BACKLOG.md; see docs/adr/0009-licensing.md.

SHELL := /bin/bash

# Shell sources that get shellcheck and shfmt. profiledef.sh is excluded
# on purpose: mkarchiso sources it, so every variable in it looks unused
# to shellcheck, and its spacing follows the upstream profile.
SHELL_SRCS := $(wildcard scripts/*.sh) \
              archiso/airootfs/usr/local/bin/boot-report \
              archiso/airootfs/usr/local/bin/omidenos-session \
              archiso/airootfs/root/customize_airootfs.sh

# QML is checked because the greeter theme ships in the image and a syntax
# error there is a black login screen, not a failed build.
QML_SRCS := archiso/airootfs/usr/share/sddm/themes/omidenos/Main.qml \
            scripts/preview-greeter.qml

.PHONY: help lint lint-style brand-scan strict tests

# Byte-code never lands in the repo (reuse lint walks the tree and would
# flag stray .pyc files).
export PYTHONDONTWRITEBYTECODE := 1

help:
	@echo "Targets:"
	@echo "  lint        - run all static checks (uses installed tools, reports missing ones)"
	@echo "  lint-style  - repository style checks (no work-item markers, no emoji, no marketing words)"
	@echo "  brand-scan  - brand scan, strict mode over first-party sources"
	@echo "  tests       - unit tests (python unittest)"
lint: lint-style brand-scan tests
	@mkdir -p build/pycache
	@PYTHONPYCACHEPREFIX=build/pycache python3 -m py_compile \
		scripts/lint-style scripts/brand-scan scripts/compose-artwork.py
	@if command -v shellcheck >/dev/null 2>&1; then shellcheck $(SHELL_SRCS); else echo "SKIP: shellcheck not installed"; fi
	@if command -v shfmt >/dev/null 2>&1; then shfmt -d $(SHELL_SRCS); else echo "SKIP: shfmt not installed"; fi
	@if command -v ruff >/dev/null 2>&1; then ruff check scripts tests; else echo "SKIP: ruff not installed"; fi
	@found=0; for bin in qmllint6 qmllint /usr/lib/qt6/bin/qmllint; do \
		if command -v $$bin >/dev/null 2>&1; then \
			found=1; \
			$$bin --ignore-settings --unqualified disable $(QML_SRCS) || exit 1; \
			break; \
		fi; \
	done; [ $$found = 1 ] || echo "SKIP: qmllint not installed"

	@if command -v mypy >/dev/null 2>&1; then mypy --strict tests; else echo "SKIP: mypy not installed"; fi
	@if command -v reuse >/dev/null 2>&1; then reuse lint; else echo "SKIP: reuse not installed"; fi
	@echo "lint: done (skipped tools are listed above)"

lint-style:
	@./scripts/lint-style

brand-scan:
	@./scripts/brand-scan --mode strict

tests:
	@python3 -m unittest discover -s tests -p 'test_*.py' -v
