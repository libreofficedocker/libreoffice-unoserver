#!/bin/sh
set -e
. /etc/os-release

ME=$(basename "$0")
PID=$$
logv() { echo "$ME [$(date)]: $* "; }

LIBREOFFICE_VERSION=$(libreoffice --version)
PYTHON_VERSION=$(python --version)
JRE_VERSION=$(java --version)

logv "Main process running pid $PID"
logv "$NAME version: $VERSION_ID"
logv "Python version: $PYTHON_VERSION"
echo "$JRE_VERSION" | while read -r a; do logv "$a"; done
logv "$LIBREOFFICE_VERSION"

exec sleep infinity
