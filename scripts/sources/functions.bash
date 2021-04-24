#!/bin/bash

########################
#   Useful Variables   #
########################
COLOR_DEFAULT="\e[39m"
COLOR_GREEN="\e[92m"
COLOR_RED="\e[31m"
COLOR_MAGENTA="\e[95m"
RESET="\e[0m"
current_dir=$(pwd)
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

########################
#   Useful Functions   #
########################

parse_formats (){
local formats_list="$1"
declare -i n=0
for format in ${formats_list}; do
	declare -i curr=$(find "${music_dir}" -name "*.${format}" | wc -l)
	n=$n+$curr
done
echo $n
}

if [ "$#" -ne 1 ]; then
	echo -e "${COLOR_RED}Wrong number of arguments !${RESET}"
	echo -e "${COLOR_GREEN}USAGE : ${RESET} $0 ${COLOR_MAGENTA} dir_to_analyze${RESET}"
	exit 0
fi