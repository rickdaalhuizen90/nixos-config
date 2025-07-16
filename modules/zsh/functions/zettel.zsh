zettel() {
    local ZETTEL_PATH="$HOME/Documents/Notes"
    mkdir -p "$ZETTEL_PATH"

    local TIMESTAMP=$(date +"%Y%m%d%H%M")

    local TITLE
    if [ -n "$1" ]; then
        TITLE="$1"
    else
        read -p "Enter note title: " TITLE
    fi

    local SLUG=$(echo "$TITLE" | iconv -t ascii//TRANSLIT | sed -r 's/[^a-zA-Z0-9]+/-/g' | sed -r 's/^-+|-+$//g' | tr '[:upper:]' '[:lower:]')
    local FILENAME="${ZETTEL_PATH}/${TIMESTAMP}-${SLUG}.md"

    cat << EOF > "$FILENAME"
---
title: "$TITLE"
date: $(date +"%Y-%m-%d %H:%M:%S")
tags:
---

# $TITLE


EOF

    echo "Created: $FILENAME"
}

