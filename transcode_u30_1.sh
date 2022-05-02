#!/bin/bash

INPUT_FILE=$1
OUTPUT_DIR=$2
OUTPUT_FILE_PREFIX_NAME=$3

echo "= activating drm."

./drm_man --conf=conf.json --cred=cred.json

source /opt/xilinx/xcdr/setup.sh

FFMPEG_ARGS="-c:v mpsoc_vcu_h264 -i ${INPUT_FILE} -cores 4 \
-filter_complex 'multiscale_xma= outputs=1: \
out_1_width=3840: out_1_height=2160: out_1_rate=full[vid]; [0:1]asplit= outputs=1[aud]' \
-map '[vid]' -b:v 8M -c:v mpsoc_vcu_h264 \
-map '[aud]' -c:a aac \
-y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_4k30fps.mp4"
cmd="time ffmpeg -hide_banner ${FFMPEG_ARGS}"

cmd_arr=(${cmd})
for i in ${!cmd_arr[@]}
do
  if [ ${cmd_arr[${i}]} == "-filter_complex" ] || [ ${cmd_arr[${i}]} == "-map" ] || [ ${cmd_arr[${i}]} == "out_1_width" ]; then
    cmd_arr[${i}]="\n\t\t${cmd_arr[${i}]}"
  fi
done
cmd_pretty=${cmd_arr[@]}

echo
echo -e "= COMMAND \n> ${cmd}"
read ENTER
eval $cmd

killall drm_man
echo
echo "= deactivating drm"

echo
echo "= results below ->"
ls -lht ${OUTPUT_DIR}

echo
echo "= finish"