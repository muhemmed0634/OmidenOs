# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause

# ADR-0008: Brand scan design

Status: Accepted (Phase 1)

## Context

Section 6.2/6.4 requires zero third-party distribution names on S0/S1
surfaces, with documented allowlist rows for anything remaining. The
scan must also avoid the false positives demonstrated in the Phase 0
inventory (`search`, `research`, `architecture` in Calamares sources).

## Decision

`scripts/brand-scan` (Python 3, stdlib only) with:

- `branding/forbidden-terms.toml`: pattern list with stable ids, word
  boundaries where needed (`\bAUR\b`), and substring patterns for
  cmdline-parameter families. Words containing `arch` are not
  forbidden; `tests/test_forbidden_terms.py` locks positive and
  negative fixtures.
- `branding/upstream-allowlist.toml`: rows of (term, path regex,
  reason, optional planned_removal). A match inside an allowlisted path
  is reported as "allowlisted" but does not fail the scan; `planned_removal`
  rows must be deleted in the named phase (a Phase 3 check removes
  stale rows).
- Modes: `strict` (first-party sources) in Phase 1; `image`, `runtime`
  and `screens` follow the phase in which the corresponding artifacts
  exist (Phase 3+).

## Alternatives

- Plain grep in CI: no per-row allowlist semantics, no reporting split,
  no testable term config; rejected.
- ripgrep wrapper script: same as above, plus quoting hazards; rejected.

## Consequences

- The Phase 2 profile carries allowlisted interim matches (stock hook
  parameters in `archiso/efiboot/` and `archiso/airootfs/`) that Phase 3
  removes together with the stock hooks.
- Every allowlist row change requires a PR-level justification per
  section 6.4.
