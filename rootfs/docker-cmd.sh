#!/bin/sh
set -e

# Creating symbolic link for /fonts.d -> /usr/share/fonts/font-extras
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

# Creating symbolic link for
# /fonts.d -> /usr/share/fonts/font-extras
if [ -d "/fonts.d" ]; then
	if [ -h "/usr/share/fonts/font-extras" ]; then
		logv "The /fonts.d directory already been linked!"
	else
		logv "Creating symbolic link for /fonts.d -> /usr/share/fonts/font-extras"
		ln -s /fonts.d /usr/share/fonts/font-extras
	fi

	logv "Rebuild build font information cache files"
	fc-cache -f
fi

while true; do sleep 2; done
