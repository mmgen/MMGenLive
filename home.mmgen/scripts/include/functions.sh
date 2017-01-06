#!/bin/bash

if which infocmp >/dev/null && infocmp $TERM 2>/dev/null | grep -q 'colors#256'; then
	RED="\e[38;5;210m" YELLOW="\e[38;5;228m" GREEN="\e[38;5;157m"
	BLUE="\e[38;5;45m" RESET="\e[0m"
else
	RED="\e[31;1m" YELLOW="\e[33;1m" GREEN="\e[32;1m" BLUE="\e[34;1m" RESET="\e[0m"
fi

function msg()  { echo ${2:+$1} $PROJ_NAME: "${2:-$1}"; }
function rmsg() { echo -e ${2:+$1} $RED$PROJ_NAME: "${2:-$1}$RESET"; }
function ymsg() { echo -e ${2:+$1} $YELLOW$PROJ_NAME: "${2:-$1}$RESET"; }
function gmsg() { echo -e ${2:+$1} $GREEN$PROJ_NAME: "${2:-$1}$RESET"; }
function bmsg() { echo -e ${2:+$1} $BLUE$PROJ_NAME: "${2:-$1}$RESET"; }
function pause() { ymsg -n 'Paused.  Hit ENTER to continue: '; read junk; }

function dbecho() { return; echo -e "${RED}DEBUG: $@$RESET"; }
function recho() { echo -e ${2:+$1} "$RED${2:-$1}$RESET"; }
function yecho() { echo -e ${2:+$1} "$YELLOW${2:-$1}$RESET"; }
function gecho() { echo -e ${2:+$1} "$GREEN${2:-$1}$RESET"; }
function becho() { echo -e ${2:+$1} "$BLUE${2:-$1}$RESET"; }

function exec_or_die() {
	set +x
	eval "$@" || {
		echo -e "$RED$PROJ_NAME: '$@' failed, line number $BASH_LINENO$RESET"
		exit 1
	}
}

function cf_write() {
	ACTION='write'
	PAT='^(cf_uncomment|cf_append|cf_edit|cf_insert)$'
	echo -n "${FUNCNAME[1]}" | egrep -q "$PAT" && ACTION=${FUNCNAME[1]/cf_}

	IN=$1 TEXT=$2 REPL=$3 SED_OUT='/tmp/sed.out'
#	echo -e  "$GREEN${ACTION%e}ing $IN $RESET"
	if true; then OUT=$1; else OUT='/tmp/debug.out'; fi # DEBUG
	if [ "$ACTION" == 'append' ]; then
		NLINES=`echo -e "$TEXT" | wc -l`
		A="`tail -n$NLINES $IN`"
		B=`echo -e "$TEXT"`
		[ "$A" == "$B" ] || echo -e "$TEXT" >> $OUT
	elif [ "$ACTION" == 'uncomment' ]; then
		PAT='^#\s*'${TEXT// /\\s*}'\s*'
		sed "s/$PAT/$TEXT/" $IN > $SED_OUT
		cat $SED_OUT > $OUT
	elif [ "$ACTION" == 'edit' ]; then
		sed "s/$TEXT/${REPL//\//\\/}/" $IN > $SED_OUT
        if diff $IN $SED_OUT >/dev/null; then
            return 1
        else
            su -c "cat $SED_OUT > $OUT"
            return 0
        fi
	elif [ "$ACTION" == 'insert' ]; then # insert REPL before first occurrence of TEXT
		LNUM=$(grep -n -m1 "$TEXT" $IN | sed 's/:.*//')
		(head -n$((LNUM-1)) $IN; echo "$REPL"; tail -n+$LNUM $IN) > $SED_OUT
		exec_or_die "cat $SED_OUT > $OUT"
	else
		echo -e "$TEXT" > $OUT
	fi
}
function cf_append()    { cf_write "$@"; }
function cf_uncomment() { cf_write "$@"; }
function cf_edit()      { cf_write "$@"; }
function cf_insert()    { cf_write "$@"; }
