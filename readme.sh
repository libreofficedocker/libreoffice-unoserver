#!/usr/bin/env bash

README_FILE="README.md"
TEMPLATE_FILE="README.template.md"
VERSION_LOCK_FILE="version-lock.json"

# Inject value into README.md
function readme() {
    local key=$1
    local value=$2

    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' -e "s|<!--$key-->|$value|" $README_FILE
    else
        sed -i -e "s|<!--$key-->|$value|" $README_FILE
    fi
}

echo "- Removing old $README_FILE"
if [ -f "$README_FILE" ]; then
    rm -f $README_FILE
fi
cp $TEMPLATE_FILE $README_FILE

echo "- Generate supported releases list..."
md_releases="\n"
releases=(`jq -cr '. | join(" ")' ${VERSION_LOCK_FILE}`)
for release in "${releases[@]}"; do
    md_releases+="\n- \`$release\`"
done
readme releases "$md_releases"
