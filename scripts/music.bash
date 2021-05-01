#!/bin/bash
current_dir=$(pwd)
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${script_dir}/sources/functions.bash"

if [ "$#" -ne 1 ]; then
	echo -e "${COLOR_RED}Wrong number of arguments !${RESET}"
	echo -e "${COLOR_GREEN}USAGE : ${RESET} $0 ${COLOR_MAGENTA} dir_to_analyze${RESET}"
	exit 0
fi

music_dir=$(getAbsolutePath "$1")
echo -e "Music dir set to : ${music_dir}${RESET}"

lossless_formats="flac alac aiff wav"
compressed_formats="mp3 aac m4a ogg"
all_formats="${lossless_formats} ${compressed_formats}"


echo -e "${COLOR_MAGENTA}Lossless formats : ${lossless_formats}${RESET}"
echo -e "Parsing lossless formats."
declare -i n_lossless=$(parseFormats "${lossless_formats}" "${music_dir}")

echo -e "${COLOR_MAGENTA}Compressed formats : ${compressed_formats}${RESET}"
echo -e "Parsing compressed formats."
declare -i n_compressed=$(parseFormats "${compressed_formats}" "${music_dir}")

echo -e "Computing Quality Ratio"
declare -i numerator=$((10000*$n_lossless))
declare -i quality_ratio=$(($numerator / ($n_lossless+$n_compressed)))
declare -i int_part=$(($quality_ratio / 100))
declare -i float_part=$(($quality_ratio - $int_part * 100))

echo -e "Computing Average Bitrate"
declare -i avg_bitrate=$(averageData "Bit rate" "${all_formats}" "${music_dir}")

#Summary
echo -e "${COLOR_RED}Found $n_lossless lossless files.${RESET}"
echo -e "${COLOR_RED}Found $n_compressed compresssed files.${RESET}"
echo -e "${COLOR_RED}Quality ratio = $int_part.$float_part%${RESET}"
echo -e "${COLOR_RED}Average Bitrate = ${avg_bitrate}kbps${RESET}"
