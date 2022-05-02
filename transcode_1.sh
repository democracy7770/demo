#!/bin/bash

INPUT_FILE=$1
OUTPUT_DIR=$2
OUTPUT_FILE_PREFIX_NAME=$3

FFMPEG_ARGS="-i ${INPUT_FILE} -vf 'scale=3840x2160:flags=lanczos' -c:v libx264 -threads 4 -c:a aac -r 15 -b:v 8M -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_4k15fps_1.mp4"

#FFMPEG_ARGS="-i ${INPUT_FILE} -s 3840x2160 -c:v libx264 -threads 4 -c:a aac -b:v 8M -r 15 -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_4k15fps.mp4"

cmd="time ffmpeg_nou30 -hide_banner ${FFMPEG_ARGS}"

cmd_arr=(${cmd})
for i in ${!cmd_arr[@]}
do
  if [ ${cmd_arr[${i}]} == "-filter_complex" ] || [ ${cmd_arr[${i}]} == "-map" ] || [ ${cmd_arr[${i}]} == "-vf" ]; then
    cmd_arr[${i}]="\n\t\t${cmd_arr[${i}]}"
  fi
done
cmd_pretty=${cmd_arr[@]}

echo
echo -e "= COMMAND \n>  ${cmd_pretty}"
read ENTER
eval $cmd

echo
echo "= results below ->"
ls -lht ${OUTPUT_DIR}

echo
echo "= finish"