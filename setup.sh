#!/usr/bin/env bash
#
# Bootstrap the public support repository.
#
# Prerequisites:
#   - GitHub CLI installed and authenticated:  gh auth login
#   - You are an owner/admin of the target GitHub organization
#
# Usage:
#   ./setup.sh YOUR-ORG YOUR-REPO
#
set -euo pipefail

ORG="${1:?Usage: ./setup.sh YOUR-ORG YOUR-REPO}"
REPO="${2:?Usage: ./setup.sh YOUR-ORG YOUR-REPO}"
FULL="${ORG}/${REPO}"

echo "==> Creating public repository ${FULL}"
gh repo create "${FULL}" \
  --public \
  --description "Issue tracker and community support for Art2link ESB" \
  --disable-wiki

echo "==> Placeholder substitution"
# Replace placeholders across the scaffold before the first commit.
grep -rl 'Cerebrum-City/art2link-support' . | xargs sed -i.bak "s|Cerebrum-City/art2link-support|${FULL}|g"
find . -name '*.bak' -delete
echo "    Remember to also replace art2link.com and Art2link ESB by hand."

echo "==> Initial commit"
git init -q
git add .
git commit -qm "Bootstrap support repository"
git branch -M main
git remote add origin "https://github.com/${FULL}.git"
git push -qu origin main

echo "==> Enabling Discussions and disabling unused features"
gh api -X PATCH "repos/${FULL}" \
  -F has_discussions=true \
  -F has_wiki=false \
  -F has_projects=false \
  -F allow_forking=true \
  --silent

echo "==> Enabling private vulnerability reporting"
gh api -X PUT "repos/${FULL}/private-vulnerability-reporting" --silent

echo "==> Triggering label sync"
gh workflow run labels-sync.yml --repo "${FULL}" || \
  echo "    (Run it manually from the Actions tab if this failed.)"

cat <<EOF

Done. Remaining manual steps (these cannot be scripted):

  1. Discussions categories — Settings > Discussions, or the Discussions tab.
     Create: Q&A (answerable), Ideas (open-ended), Announcements
     (maintainers only), Show and tell. Delete the defaults you do not want.

  2. Issue types — organization Settings > Planning > Issue types.
     Ensure Bug, Feature, and Task exist.

  3. Issue fields — organization Settings > Planning > Issue fields.
     See the install guide for the four fields to create and their visibility.

  4. Repository secrets for the Azure DevOps bridge —
     Settings > Secrets and variables > Actions:
       Secrets:   ADO_ORG, ADO_PROJECT, ADO_PAT
       Variables: ADO_AREA_PATH  (optional)

  5. Branch protection on main, and add maintainers as a team with Triage
     or Write access.

EOF
