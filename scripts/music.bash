#!/bin/bash

current_dir=$(pwd)
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${script_dir}/sources/functions.bash"

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
