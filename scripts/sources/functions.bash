#!/bin/bash

########################
#   Useful Variables   #
########################
COLOR_DEFAULT="\e[39m"
COLOR_GREEN="\e[92m"
COLOR_RED="\e[31m"
COLOR_MAGENTA="\e[95m"
RESET="\e[0m"

########################
#   Useful Functions   #
########################

getAbsolutePath(){
local cur_dir=$(pwd)
local dir="$1"
cd "${dir}"
echo $(pwd)
cd "${cur_dir}"
}

buildFindPatterns(){
local formats_list="$1"
local find_pattern="-name"
for format in ${formats_list}; do
	find_pattern="${find_pattern} '*${format}' -o -name"
done
local find_pattern=${find_pattern::-9}
echo "${find_pattern}"
}


parseFormats(){
local formats_list="$1"
local dir=$(getAbsolutePath "$2")
local formats_patterns=$(buildFindPatterns "${formats_list}")
find_cmd="find "${dir}" -type f ${formats_patterns}"
declare -i n=$(eval ${find_cmd} | wc -l)
echo $n
}

averageData(){
local data_field="$1"
local formats_list="$2"
local dir=$(getAbsolutePath "$3")

declare -i data=0
declare -i n=0
local formats_patterns=$(buildFindPatterns "${formats_list}")

find_cmd="find "${dir}" -type f ${formats_patterns}"
local files=$(eval ${find_cmd})

while read file; do
	declare -i file_data=$(mediainfo "${file}" | grep "${data_field}[ ]*:" | tr -dc '0-9')
	if [ "$file_data" -ne 0 ]; then
		data=$data+$file_data
		n=$n+1
	fi
done <<< $(eval ${find_cmd})

local data=$((${data} / $n))
echo ${data}
}