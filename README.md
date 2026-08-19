# Art2link ESB — Issue Tracker & Community

This repository contains **no source code**. It exists so that users of
Art2link ESB have a public, searchable place to report defects and find fixes.

| I want to… | Go here |
| --- | --- |
| Report a bug | [Open an issue](../../issues/new/choose) |
| Ask a question or find a fix | [Discussions → Q&A](../../discussions/categories/q-a) |
| Request a feature | [Discussions → Ideas](../../discussions/categories/ideas) |
| Read the docs | https://www.art2link.com/documentation/ |
| Report a security vulnerability | See [SECURITY.md](SECURITY.md) — **not** a public issue |
| Talk to us commercially | https://www.art2link.com/contact/ |

## How reports are handled

1. **Triage** — a maintainer reviews the report, usually within two business
   days. It gets `needs-info`, `needs-repro`, or `confirmed`.
2. **Confirmed** — the bug is reproduced and a work item is opened in our
   internal engineering backlog. The issue stays open here as the public
   record.
3. **Fixed** — labelled `fixed-pending-release` with the target version.
4. **Released** — closed with a comment naming the shipping version.

Issues that turn out to be usage questions rather than defects are converted to
Discussions so the answer stays findable.

## What makes a report actionable

The bug form asks for version, environment, and exact reproduction steps
because those three fields are what decide whether a report can be worked on
at all. A report without them usually costs a round trip.

Please redact credentials, connection strings, endpoint URLs, and customer
data before posting. This repository is public and indexed by search engines.
