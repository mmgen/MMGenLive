#!/bin/bash

. ~/scripts/term/vars.sh

declare -A FONT_SIZES=([small]=14 [medium]=18 [large]=22)

PROGNAME=`basename $0` A=${PROGNAME#*-}
FONT_SIZE=${FONT_SIZES[${A%.sh}]}
MMTERM_FONT="xft:Mono:pixelsize=${FONT_SIZE:-${FONT_SIZES[$DFL_TERM_SIZE]}}:Bold"
MMTERM_GEOMETRY=${FONT_SIZE:+'-geometry 90x25+164+12'}

[ "$1" ] && { CARGS=" -e `eval echo $1`"; }

urxvt -T "$MMTERM_NAME" -n "$MMTERM_NAME" \
      -fg "$TEXT_COLOR" -bg "$BG_COLOR" \
      -fn "$MMTERM_FONT" -fb "$MMTERM_FONT" \
      $MMTERM_GEOMETRY $CARGS
