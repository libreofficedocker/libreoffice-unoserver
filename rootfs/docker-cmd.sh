#!/bin/sh
set -e

# This file is a noop
# It only use to keep the container running
# And add a trap for CTRL + C

ME=$(basename $0)
PID=$$

function logv() {
	echo "$ME [$(date)]: $@ "
}

function trap_SIGINT() {
	logv "Process interrupted by user!"
	CMD_TERM_SIGNAL=1

	if [ -f "/run/s6-linux-init-container-results/exitcode" ]; then
		echo "${1:-0}" > /run/s6-linux-init-container-results/exitcode
	fi

	test -f "/run/s6/basedir/bin/halt" && /run/s6/basedir/bin/halt
}

logv "Main process running pid $PID"
trap 'trap_SIGINT' SIGINT
while true; do sleep 2; done
