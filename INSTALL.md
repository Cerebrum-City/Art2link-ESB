# Installation guide — Art2link ESB support repo

Estimated time: 45 minutes, most of it in the GitHub web UI on steps that
cannot be scripted.

---

## Step 0 — Prerequisites

- A **GitHub organization**. Not a personal account. Issue types and issue
  fields are organization-scoped and do not exist on personal repos, even on
  paid personal plans.
- The [GitHub CLI](https://cli.github.com) installed and authenticated:
  ```bash
  gh auth login
  ```
- Owner or admin rights on the organization.
- An Azure DevOps personal access token with **Work Items → Read & write**
  scope, if you want the bridge.

---

## Step 1 — Placeholders (already done)

All placeholders are already substituted for Cerebrum-City / Art2link ESB:

| Was | Now |
| --- | --- |
| `YOUR-ORG/YOUR-REPO` | `Cerebrum-City/Art2link-ESB` |
| `https://docs.YOURDOMAIN.com` | `https://www.art2link.com/documentation/` |
| `https://YOURDOMAIN.com/contact` | `https://www.art2link.com/contact/` |
| `security@YOURDOMAIN.com` | `security@art2link.com` |
| `PRODUCT NAME` | `Art2link ESB` |

**Verify these three URLs actually resolve before pushing** — I inferred them
from the public site and they may not exist yet:

```bash
curl -sI https://www.art2link.com/documentation/    | head -1
curl -sI https://www.art2link.com/contact/ | head -1
```

If either 404s, fix it now:

```bash
grep -rl 'art2link.com/documentation/' . --exclude-dir=.git \
  | xargs sed -i 's|https://www.art2link.com/documentation/|CORRECT-URL|g'
```

Same for `security@art2link.com` — confirm the mailbox exists and is monitored,
or point SECURITY.md at an address that is.

The **Affected area** dropdown in `bug_report.yml` and the `area/*` labels in
`labels.yml` now mirror Art2link's constructs: Console/Designer, Schemas, Maps,
Itineraries, Pipelines, Adapters, EDI, HL7/FHIR, Tracking, Runtime, Deployment,
Migration AI, Security, Docs. Adjust if your internal naming differs — the two
lists must stay in agreement.

## Step 2 — Create and push the repo

```bash
./setup.sh YOUR-ORG YOUR-REPO
```

This creates the public repo, pushes the scaffold, enables Discussions,
disables the wiki and projects, turns on private vulnerability reporting, and
triggers the label sync.

If you prefer to do it by hand:

```bash
gh repo create ORG/REPO --public --disable-wiki
git init && git add . && git commit -m "Bootstrap support repository"
git branch -M main
git remote add origin https://github.com/ORG/REPO.git
git push -u origin main
gh api -X PATCH repos/ORG/REPO -F has_discussions=true -F has_projects=false
gh api -X PUT repos/ORG/REPO/private-vulnerability-reporting
```

---

## Step 3 — Discussions categories

**Repo → Discussions tab → edit categories.** These cannot be created via API.

| Category | Format | Notes |
| --- | --- | --- |
| Q&A | **Answerable** | The fixes library. Format matters — only answerable categories support marked answers. |
| Ideas | Open-ended | Feature requests, keeps them out of Issues |
| Announcements | Announcement | Release notes. Maintainers post, anyone comments. |
| Show and tell | Open-ended | Integrations and configs users have built |

Delete the default *General* category. It becomes a dumping ground.

---

## Step 4 — Issue types (organization level)

**Organization Settings → Planning → Issue types.**

Confirm `Bug`, `Feature`, and `Task` exist. The issue forms reference `Bug` and
`Task` via the `type:` key — if a type is missing, the form silently ignores it.

---

## Step 5 — Issue fields (organization level)

**Organization Settings → Planning → Issue fields.** Up to 25 per org, and each
field has a visibility setting that only takes effect on public repos.

| Field | Type | Options | Pin to | Visibility |
| --- | --- | --- | --- | --- |
| Severity | Single select | S1 Critical, S2 Major, S3 Minor, S4 Cosmetic | Bug | **Public** |
| Fixed in version | Text | — | Bug | **Public** |
| Root cause | Single select | Code, Config, Data, Third-party, User error | Bug | Organization only |
| ADO work item | Text | — | Bug | Organization only |

The visibility column is the important part. Reporters see severity and the
fix version; your triage data stays internal on a public tracker.

Four org default fields (Priority, Effort, Start date, Target date) already
exist. Leave them alone or unpin them from Bug — do not duplicate Severity with
Priority, they are different things and having both invites inconsistent use.

---

## Step 6 — Azure DevOps bridge

**Repo Settings → Secrets and variables → Actions.**

Secrets:

| Name | Value |
| --- | --- |
| `ADO_ORG` | your Azure DevOps organization name |
| `ADO_PROJECT` | the project name |
| `ADO_PAT` | PAT with Work Items read & write |

Variables (optional):

| Name | Value |
| --- | --- |
| `ADO_AREA_PATH` | e.g. `Art2link\Runtime` — omit to use the project default |

Test it: open a throwaway issue, apply the `confirmed` label, then check
**Actions → Create Azure DevOps work item → run summary** for the created work
item link.

Note that the workflow fires on every `confirmed` labelling, so removing and
re-adding the label creates a second work item. If that becomes a problem,
add a guard that checks for an existing `github` tag match before creating.

---

## Step 7 — Access and moderation

- **Settings → Collaborators and teams** — add your maintainers. `Triage` is
  enough for anyone who only labels and closes; reserve `Write` for people
  editing the templates.
- **Settings → Moderation → Interaction limits** — leave off by default, and
  know where it is for the day you get a spam wave.
- **Settings → Rules** — protect `main` so template changes go through a PR.
- Add a `CODE_OF_CONDUCT.md`. GitHub will offer the Contributor Covenant
  template from **Insights → Community Standards**.

---

## Step 8 — Close the loop with your docs

The tracker only pays off if it feeds the documentation:

1. Link **Known Issues** in the docs to a filtered issue view:
   `https://github.com/ORG/REPO/issues?q=is:open+label:confirmed`
2. When a Q&A answer gets repeated three times, promote it to a docs page and
   link back to the discussion.
3. On each release, close the `fixed-pending-release` issues with a comment
   naming the version, and link the release notes discussion.

Skipping step 8 is how public trackers become graveyards.
