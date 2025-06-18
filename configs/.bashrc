# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

if test -z "${XDG_RUNTIME_DIR}"; then
	export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
	if ! test -d "${XDG_RUNTIME_DIR}"; then
		mkdir "${XDG_RUNTIME_DIR}"
		chmod 0700 "${XDG_RUNTIME_DIR}"
	fi
fi

[ "$(tty)" = "/dev/tty1" ] && exec=env WLR_NO_HARDWARE_CURSORS=1 dbus-run-session sway 
#export WINEPREFIX=/path/to/wineprefix
export PATH=/home/coal/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/opt/bin:/usr/lib/llvm/19/bin:/etc/eselect/wine/bin
