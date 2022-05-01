#!/bin/bash

INPUT_FILE=$1
OUTPUT_DIR=$2
OUTPUT_FILE_PREFIX_NAME=$3

#FFMPEG_ARGS="-i ${INPUT_FILE} \
#-vf 'scale=3840x2160:flags=lanczos' \
#-c:v libx264 -c:a copy -r 60 -b:v 1M -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_4k.mp4"

#FFMPEG_ARGS="-i ${INPUT_FILE} \
#-s 1280x720 -c:v libx264 -c:a aac -b:v 2.5M -r 30 -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_720p30fps.mp4 \
#-s 1920x1080 -c:v libx264 -c:a aac -b:v 4M -r 15 -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_1080p15fps.mp4 \
#-s 2560x1440 -c:v libx264 -c:a aac -b:v 8M -r 15 -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_1440p15fps.mp4"

FFMPEG_ARGS="-i ${INPUT_FILE} \
-filter_complex 'split=3[a][b][c]; \
[a]scale=1280x720:flags=lanczos[aa]; \
[b]scale=1920x1080:flags=lanczos[bb]; \
[c]scale=2560x1440:flags=lanczos[cc]' \
-map '[aa]' -c:v libx264 -c:a copy -b:v 2.5M -r 30 -y output/iu_720p30.mp4 \
-map '[bb]' -c:v libx264 -c:a copy -b:v 4M -r 15 -y output/iu_1080p15.mp4 \
-map '[cc]' -c:v libx264 -c:a copy -b:v 8M -r 15 -y output/iu_1440p15.mp4"

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