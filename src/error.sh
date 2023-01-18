#!/usr/bin/env bash
Error() {
	Reset() { echo -en "\e[0m"; }
	Bold() { echo -en "\e[1m"; }
	LightRed() { echo -en "\e[91m"; }
	Header() { Bold; LightRed; echo -en 'ERROR '"$ERR_CODE"': '; Reset; LightRed; }
	Show() { Reset; echo -e "$(Header)""$msg" 1>&2; Reset; }
	local ERR_CODE=$BASH_LINENO; [ 0 -eq $ERR_CODE ] && ERR_CODE=255;
	local args=("$@"); local msg="$(IFS=$'\n'; echo -e "${args[*]}")"
	Show
	exit $ERR_CODE
}
Success() {
	local args=("$@"); local msg="$(IFS=$'\n'; echo -e "${args[*]}")"
	Reset() { echo -en "\e[0m"; }
	Bold() { echo -en "\e[1m"; }
	LightGreen() { echo -en "\e[92m"; }
	Show() { Reset; Bold; LightGreen; echo -e "$msg" 1>&2; Reset; }
	Show
}
