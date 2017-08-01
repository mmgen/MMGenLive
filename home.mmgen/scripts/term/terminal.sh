#!/bin/bash

. ~/scripts/term/vars.sh

[ "$1" ] && { CARGS=" -e `eval echo $1`"; }

shift; eval $@ # all args after first are env vars

declare -A FONT_SIZES=([small]=14 [medium]=18 [large]=22)

A=$(basename $0) B=${A#*-} FONT_SIZE=${FONT_SIZES[${B%.sh}]}
MMTERM_FONT="xft:Mono:pixelsize=${FONT_SIZE:-${FONT_SIZES[$DFL_TERM_SIZE]}}:Bold"
[ "$MMTERM_GEOMETRY" ] || MMTERM_GEOMETRY=${FONT_SIZE:+'-geometry 90x25+164+12'}

urxvt -sl 0 -T "$MMTERM_NAME" -n "$MMTERM_NAME" \
      -fg "$TEXT_COLOR" -bg "$BG_COLOR" \
      -fn "$MMTERM_FONT" -fb "$MMTERM_FONT" \
      $MMTERM_GEOMETRY $CARGS
