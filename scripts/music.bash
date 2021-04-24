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

music_dir="$1"
echo -e "Music dir set to : ${music_dir}${RESET}"

lossless_formats="flac alac aiff wav"
compressed_formats="mp3 aac m4a ogg"

echo -e "${COLOR_MAGENTA}Lossless formats : ${lossless_formats}${RESET}"
echo -e "Parsing lossless formats."
declare -i n_lossless=$(parse_formats "${lossless_formats}")

echo -e "${COLOR_MAGENTA}Compressed formats : ${compressed_formats}${RESET}"
echo -e "Parsing compressed formats."
declare -i n_compressed=$(parse_formats "${compressed_formats}")

declare -i numerator=$((10000*$n_lossless))
declare -i quality_ratio=$(($numerator / ($n_lossless+$n_compressed)))
declare -i int_part=$(($quality_ratio / 100))
declare -i float_part=$(($quality_ratio - $int_part * 100))

#Summary
echo -e "${COLOR_RED}Found $n_lossless lossless files."
echo -e "${COLOR_RED}Found $n_compressed compresssed files."
echo -e "${COLOR_RED}Quality ratio = $int_part.$float_part%"
