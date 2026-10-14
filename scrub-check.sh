#!/usr/bin/env bash
# Run before every commit to this public repo. Exit 1 when a personal or project reference remains.
cd "$(dirname "$0")"
pat='suryaiq|\bsurya\b|\bbdr\b|bell ?copilot|\baviary\b|watchtower|flatsignal|landsignal|rolesignal|\bhexis\b|\bsoma\b|\bcerta\b|mercurius|sky.?above|\brahul\b|kingsbridge|\bmythic\b|anamnesis|nanaji|~/Cursor|ssh xps|xps ISC|Param'"'"'s|parambahia'
hits=$(grep -rInE -i "$pat" --exclude-dir=.git . | grep -v '^./LICENSE' | grep -v 'scrub-check.sh')
if [ -n "$hits" ]; then echo "$hits"; echo "scrub-check: FAIL"; exit 1; fi
echo "scrub-check: clean"
