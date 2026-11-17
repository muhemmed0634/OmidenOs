# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
#
# Licensing note: the root LICENSE is BSD 3-Clause (owner's file).
# Alignment with the project spec (GPL-3.0-or-later) is tracked in
# docs/BACKLOG.md; see docs/adr/0009-licensing.md.

SHELL := /bin/bash

.PHONY: help lint lint-style brand-scan strict tests

help:
	@echo "Targets:"
	@echo "  lint        - run all static checks (uses installed tools, reports missing ones)"
	@echo "  lint-style  - repository style checks (no work-item markers, no emoji, no marketing words)"
	@echo "  brand-scan  - brand scan, strict mode over first-party sources"
	@echo "  tests       - unit tests (python unittest)"
lint: lint-style brand-scan tests
	@python3 -m py_compile scripts/lint-style scripts/brand-scan
	@if ls scripts/*.sh >/dev/null 2>&1; then \
		if command -v shellcheck >/dev/null 2>&1; then shellcheck scripts/*.sh; else echo "SKIP: shellcheck not installed"; fi; \
		if command -v shfmt >/dev/null 2>&1; then shfmt -d scripts; else echo "SKIP: shfmt not installed"; fi; \
	else \
		echo "SKIP: no shell scripts present"; \
	fi
	@if command -v ruff >/dev/null 2>&1; then ruff check scripts tests; else echo "SKIP: ruff not installed"; fi
	@if command -v mypy >/dev/null 2>&1; then mypy --strict scripts; else echo "SKIP: mypy not installed"; fi
	@if command -v reuse >/dev/null 2>&1; then reuse lint; else echo "SKIP: reuse not installed"; fi
	@echo "lint: done (skipped tools are listed above)"

lint-style:
	@./scripts/lint-style

brand-scan:
	@./scripts/brand-scan --mode strict

tests:
	@python3 -m unittest discover -s tests -p 'test_*.py' -v
