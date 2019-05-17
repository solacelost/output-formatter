#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-only
#
#    format_test.sh - a script to demonstrate functionality of Formatter
#    Copyright (C) 2019 James Harmison <jharmison at gmail dot com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

. formatter

################################################################################

short_line='this is a short line.'
long_line='this is a very long line of text. i expect it to need to wrap when given a failure or success. this is accounting for the default width of 80 characters.'
blue_line="${blue_text}this is a line of blue text.${ansi_reset}"
blue_long_line="${blue_text}this is a very long line of blue text. i expect it to need to wrap when given a failure or success. this is accounting for the default width of 80 characters.${ansi_reset}"
no_space_line='AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
eighty_dashes=$(for i in $(seq 80); do echo -n '-'; done; echo)

################################################################################

echo 'running short line with success:'
error_run "$short_line" true
repeat_char '-' $FORMATTER_MAX_WIDTH
echo; echo
echo 'running short line with failure:'
error_run "$short_line" false
repeat_char '-' $FORMATTER_MAX_WIDTH
echo; echo
echo 'running short line with warning:'
warn_run "$short_line" false
repeat_char '-' $FORMATTER_MAX_WIDTH
echo; echo
echo 'running long duration test with long line:'
outfile=$(mktemp)
error_run "$long_line" dd if=/dev/urandom of="$outfile" bs=1M count=256 conv=fsync
repeat_char '-' $FORMATTER_MAX_WIDTH
rm -f "$outfile"
echo; echo
echo 'running blue line:'
error_run "$blue_line" true
repeat_char '-' $FORMATTER_MAX_WIDTH
echo; echo
echo 'running blue long line:'
error_run "$blue_long_line" true
repeat_char '-' $FORMATTER_MAX_WIDTH
echo; echo
echo 'running no space line to break things:'
error_run "$no_space_line" true
repeat_char '-' $FORMATTER_MAX_WIDTH
echo; echo

################################################################################

FORMATTER_AUTO_WIDTH=0
FORMATTER_MAX_WIDTH=100
echo 'setting max width to 100, turning off auto'
echo; echo;

echo 'running non-auto max width of 100 run w/ short line:'
error_run "$short_line" true
repeat_char '-' $FORMATTER_MAX_WIDTH
echo; echo
echo 'running no space line to break things:'
error_run "$no_space_line" true
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
exec 7>tmp_file
echo 'running non-auto max width long blue line with logging of cmd output:'
error_run "$blue_long_line" head -10 /etc/passwd
repeat_char '-' $FORMATTER_MAX_WIDTH
echo ; echo 'output from last command:'
cat tmp_file
rm -f tmp_file
echo; echo

################################################################################

FORMATTER_AUTO_WIDTH=1
FORMATTER_MAX_WIDTH=80
echo 'resetting max width to 80, turning on auto'
echo; echo

echo 'outputting wrapped long line:'
wrap "$long_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'outputting wrapped long blue line:'
wrap "$blue_long_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'outputting centered short line:'
center_wrap "$short_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'outputting centered long line:'
center_wrap "$long_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'outputting centered long blue line:'
center_wrap "$blue_long_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo

################################################################################

echo 'wrapping short line in centered box:'
center_border_text "$short_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'wrapping long line in centered soft box:'
center_border_text "$long_line" -s
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'auto-width box with short line:'
border_text "$short_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'auto-width box with long blue line:'
border_text "$blue_long_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo

################################################################################

FORMATTER_MAX_WIDTH=60
echo 'setting max width to 60'
echo; echo

echo 'outputting wrapped long line:'
wrap "$long_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'outputting wrapped long blue line:'
wrap "$blue_long_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'outputting centered short line:'
center_wrap "$short_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'outputting centered long line:'
center_wrap "$long_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'outputting centered long blue line:'
center_wrap "$blue_long_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo

################################################################################

echo 'wrapping short line in centered box:'
center_border_text "$short_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'wrapping long line in centered soft box:'
center_border_text "$long_line" -s
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'fixed-width box with short line:'
border_text -f "$short_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'fixed-width box with long blue line:'
border_text -f "$blue_long_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'auto-width soft box with blue line and bold magenta outlines:'
border_text -c "${magenta_bold}" $blue_line -s
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'white background black frame auto width box with short line:'
border_text -c "${white_bg}${black_text}" "$short_line"
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
echo 'red background white frame centered auto width box with red short line:'
center_border_text -c "${red_bg}${white_text}" $(_ansi_wrap $red_text $short_line)
repeat_char '-' $FORMATTER_MAX_WIDTH; echo; echo
