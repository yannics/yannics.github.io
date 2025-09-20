#!/bin/bash

# script to add video to share

echo "This script and video.html should be in the same directory."

echo -n "Title : "
read title
echo -n "Video : "
read video

timestamp=$(date +%s)

echo `printf "%b\n"` > tmp.txt
echo '<div class="parentDiv">' >> tmp.txt
#echo '<a class="src" href="https://www.youtube.com/watch?v='$youtuberef'">' >> tmp.txt
#echo $youtuberef >> tmp.txt
#echo '</a>' >> tmp.txt
echo '<video id="'$timestamp'" controls>' >> tmp.txt
echo '<source src="video/'$timestamp'.mp4" type="video/mp4">' >> tmp.txt
echo '<source src="video/'$timestamp'.webm" type="video/webm">' >> tmp.txt
echo '<source src="video/'$timestamp'.ogg" type="video/ogg">' >> tmp.txt
echo 'Your browser does not support the video tag.' >> tmp.txt
echo '</video>' >> tmp.txt
echo '<p class="title">' >> tmp.txt
echo $title >> tmp.txt
echo '</p>' >> tmp.txt
echo '<script>' >> tmp.txt
echo 'const vid"'$timestamp'" = document.getElementById("'$timestamp'");' >> tmp.txt
echo 'vid"'$timestamp'".volume = 0.5;' >> tmp.txt
echo '</script>' >> tmp.txt
echo '</div>' >> tmp.txt

sed '/<!--4sh-->/ r tmp.txt' video.html > tmp.html

target=`pwd`/video/$timestamp.mp4
cp "$video" $target
ffmpeg -i "${target}" -vn -acodec libvorbis -y "${target%.mp4}.ogg" >/dev/null 2>&1
ffmpeg -i "$target" -b:v 0 -crf 30 -pass 1 -an -f webm -y /dev/null
ffmpeg -i "$target" -b:v 0 -crf 30 -pass 2 "${target%.mp4}.webm"
mv tmp.html video.html
rm tmp.txt
