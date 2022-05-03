#!/bin/bash

INPUT_FILE=$1
OUTPUT_DIR=$2
OUTPUT_FILE_PREFIX_NAME=$3

echo "= activating drm."

./drm_man --conf=conf.json --cred=cred.json

source /opt/xilinx/xcdr/setup.sh

#FFMPEG_ARGS="-c:v mpsoc_vcu_h264 -i ${INPUT_FILE} \
#-filter_complex 'multiscale_xma= outputs=5: \
#out_1_width=1280: out_1_height=720:  out_1_rate=full: \
#out_2_width=1280: out_2_height=720:  out_2_rate=half: \
#out_3_width=1920: out_3_height=1080: out_3_rate=half: \
#out_4_width=2560: out_4_height=1440: out_4_rate=half: \
#out_5_width=3840: out_5_height=2160: out_5_rate=half [vid1][vid2][vid3][vid4][vid5]; \
#[0:1]asplit=outputs=5[aud1][aud2][aud3][aud4][aud5]' \
#-map '[vid1]' -cores 4 -b:v 2.5M -c:v mpsoc_vcu_h264 -map '[aud1]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_720p30fps.mp4 \
#-map '[vid2]' -cores 4 -b:v 2.5M -c:v mpsoc_vcu_h264 -map '[aud2]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_720p15fps.mp4 \
#-map '[vid3]' -cores 4 -b:v 4M -c:v mpsoc_vcu_h264 -map '[aud3]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_1080p15fps.mp4 \
#-map '[vid4]' -cores 4 -b:v 6M -c:v mpsoc_vcu_h264 -map '[aud4]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_1440p15fps.mp4 \
#-map '[vid5]' -cores 4 -b:v 8M -c:v mpsoc_vcu_h264 -map '[aud5]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_4k15fps.mp4"

FFMPEG_ARGS="-c:v mpsoc_vcu_h264 -i ${INPUT_FILE} \
-filter_complex 'multiscale_xma= outputs=8: \
out_1_width=1280: out_1_height=720:  out_1_rate=full: \
out_2_width=1280: out_2_height=720:  out_2_rate=half: \
out_3_width=1920: out_3_height=1080: out_3_rate=half: \
out_4_width=1920: out_4_height=1080: out_4_rate=half: \
out_5_width=2560: out_5_height=1440: out_5_rate=half: \
out_6_width=2560: out_6_height=1440: out_6_rate=half: \
out_7_width=3840: out_7_height=2160: out_7_rate=half: \
out_8_width=3840: out_8_height=2160: out_8_rate=half [vid1][vid2][vid3][vid4][vid5][vid6][vid7][vid8]; \
[0:1]asplit=outputs=8[aud1][aud2][aud3][aud4][aud5][aud6][aud7][aud8]' \
-map '[vid1]' -cores 4 -b:v 2.5M -c:v mpsoc_vcu_h264 -map '[aud1]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_720p30fps.mp4 \
-map '[vid2]' -cores 4 -b:v 2.5M -c:v mpsoc_vcu_h264 -map '[aud2]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_720p15fps.mp4 \
-map '[vid3]' -cores 4 -b:v 4M -c:v mpsoc_vcu_h264 -map '[aud3]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_1080p30fps.mp4 \
-map '[vid4]' -cores 4 -b:v 4M -c:v mpsoc_vcu_h264 -map '[aud4]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_1080p15fps.mp4 \
-map '[vid5]' -cores 4 -b:v 6M -c:v mpsoc_vcu_h264 -map '[aud5]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_1440p30fps.mp4 \
-map '[vid6]' -cores 4 -b:v 6M -c:v mpsoc_vcu_h264 -map '[aud6]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_1440p15fps.mp4 \
-map '[vid7]' -cores 4 -b:v 8M -c:v mpsoc_vcu_h264 -map '[aud7]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_4k30fps.mp4 \
-map '[vid8]' -cores 4 -b:v 8M -c:v mpsoc_vcu_h264 -map '[aud8]' -c:a aac -y ${OUTPUT_DIR}/${OUTPUT_FILE_PREFIX_NAME}_u30_4k15fps.mp4"

cmd="time ffmpeg -hide_banner ${FFMPEG_ARGS}"

cmd_arr=(${cmd})
for i in ${!cmd_arr[@]}
do
  if [ ${cmd_arr[${i}]} == "-filter_complex" ] || [ ${cmd_arr[${i}]} == "-map" ] || [ ${cmd_arr[${i}]} == "-vf" ]; then
    cmd_arr[${i}]="\n\t\t${cmd_arr[${i}]}"
  fi
done
cmd_pretty=${cmd_arr[@]}

echo
echo -e "= COMMAND \n> ${cmd_pretty}"
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