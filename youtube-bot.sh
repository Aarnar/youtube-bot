#!/bin/sh

notify-send -u critical "👾 Hello.. Sir i am UP.."

cd ~/Foo/reddit/cringetopia

date=$(date +'%d_%m_%Y')

## Downloading videos url

curl -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101 Firefox/87.0" https://www.reddit.com/r/Cringetopia/top/.json 2>&1 | jq '.' | grep fallback_url | awk -F'"' '{print $4}' | sed -n '1~2p' > "$date"_urls.txt  

## Downloading videos

if [ -s "$date"_urls.txt ]
then
	mkdir $date ; cd $date 
	notify-send -u normal "👾 Sir download starting..."
	youtube-dl --external-downloader aria2c -a ~/Foo/reddit/cringetopia/"$date"_urls.txt 
	cd ../
else
	notify-send -u critical "👾 Sir cURL failure..."  
fi

## Show notification about no. of urls and videos downloaded.

nu=$(wc -l "$date"_urls.txt | awk '{print $1}')
nv=$(ls -1 $date | wc -l)
notify-send -u normal "urls > $nu videos downloaded > $nv"

## Removing videos with no audio streams.

cd $date

for file in *.mp4
do
    audio=$(ffprobe -loglevel error -select_streams a -show_entries stream=codec_type -of csv=p=0 $file)
     [ -z "$audio" ] && rm $file
done

cd ../

## Editing videos 

file_name=-1

mkdir "$date"_blurred
mkdir "$date"_finalvid


for input_file in $( ls $date )
do
	aspect_ratio=$(mediainfo "$date/$input_file" | awk '/Display aspect ratio/ {print $5}') 

	if [ "$aspect_ratio" = "16:9" ]
	then
		((file_name++))
		ffmpeg -loglevel quiet -i "$date/$input_file" -vf scale=1280:720 "$date"_blurred/$file_name.mp4
	else
		((file_name++))
		ffmpeg -loglevel quiet -i "$date/$input_file" \
		-vf 'split[original][copy];[copy]scale=ih*16/9:-1,crop=h=iw*9/16,gblur=sigma=20[blurred];[blurred][original]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2' \
		"$date"_blurred/"$file_name".mp4
	fi
done

for blurred_file in $(ls "$date"_blurred )
do
		height=$(mediainfo ""$date"_blurred/$blurred_file" | awk '/Height/ {print $3}')

		if [ "$height" = 720 ]
		then
		    cp ""$date"_blurred/$blurred_file" "$date"_finalvid/
		else
		    ffmpeg -loglevel quiet -y -i ""$date"_blurred/$blurred_file" -vf scale=1280:720 "$date"_finalvid/$blurred_file
		fi
done


## Arguments for concatenation.

input_file_args[0]="-i 0.mp4"

stream_args[0]="[0:v:0][0:a:0] concat=unsafe=1:n=1"

input_file_args[1]="-i 0.mp4 -i 1.mp4"

stream_args[1]="[0:v:0][0:a:0][1:v:0][1:a:0] concat=unsafe=1:n=2"

input_file_args[2]="-i 0.mp4 -i 1.mp4 -i 2.mp4"

stream_args[2]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0] concat=unsafe=1:n=3"

input_file_args[3]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4"

stream_args[3]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0] concat=unsafe=1:n=4"

input_file_args[4]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4"

stream_args[4]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0] concat=unsafe=1:n=5"

input_file_args[5]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4"

stream_args[5]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0] concat=unsafe=1:n=6"

input_file_args[6]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4"

stream_args[6]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0] concat=unsafe=1:n=7"

input_file_args[7]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4"

stream_args[7]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0] concat=unsafe=1:n=8"

input_file_args[8]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4"

stream_args[8]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0] concat=unsafe=1:n=9"

input_file_args[9]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4"

stream_args[9]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0] concat=unsafe=1:n=10"

input_file_args[10]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4"

stream_args[10]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0] concat=unsafe=1:n=11"

input_file_args[11]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4 -i 11.mp4"

stream_args[11]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0] concat=unsafe=1:n=12"

input_file_args[12]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4 -i 11.mp4 -i 12.mp4"

stream_args[12]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0][12:v:0][12:a:0] concat=unsafe=1:n=13"

input_file_args[13]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4 -i 11.mp4 -i 12.mp4 -i 13.mp4"

stream_args[13]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0][12:v:0][12:a:0][13:v:0][13:a:0] concat=unsafe=1:n=14"

input_file_args[14]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4 -i 11.mp4 -i 12.mp4 -i 13.mp4 -i 14.mp4"

stream_args[14]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0][12:v:0][12:a:0][13:v:0][13:a:0][14:v:0][14:a:0] concat=unsafe=1:n=15"

input_file_args[15]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4 -i 11.mp4 -i 12.mp4 -i 13.mp4 -i 14.mp4 -i 15.mp4"

stream_args[15]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0][12:v:0][12:a:0][13:v:0][13:a:0][14:v:0][14:a:0][15:v:0][15:a:0] concat=unsafe=1:n=16"

input_file_args[16]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4 -i 11.mp4 -i 12.mp4 -i 13.mp4 -i 14.mp4 -i 15.mp4 -i 16.mp4"

stream_args[16]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0][12:v:0][12:a:0][13:v:0][13:a:0][14:v:0][14:a:0][15:v:0][15:a:0][16:v:0][16:a:0] concat=unsafe=1:n=17"

input_file_args[17]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4 -i 11.mp4 -i 12.mp4 -i 13.mp4 -i 14.mp4 -i 15.mp4 -i 16.mp4 -i 17.mp4"

stream_args[17]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0][12:v:0][12:a:0][13:v:0][13:a:0][14:v:0][14:a:0][15:v:0][15:a:0][16:v:0][16:a:0][17:v:0][17:a:0] concat=unsafe=1:n=18"

input_file_args[18]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4 -i 11.mp4 -i 12.mp4 -i 13.mp4 -i 14.mp4 -i 15.mp4 -i 16.mp4 -i 17.mp4 -i 18.mp4"

stream_args[18]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0][12:v:0][12:a:0][13:v:0][13:a:0][14:v:0][14:a:0][15:v:0][15:a:0][16:v:0][16:a:0][17:v:0][17:a:0][18:v:0][18:a:0] concat=unsafe=1:n=19"

input_file_args[19]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4 -i 11.mp4 -i 12.mp4 -i 13.mp4 -i 14.mp4 -i 15.mp4 -i 16.mp4 -i 17.mp4 -i 18.mp4 -i 19.mp4"

stream_args[19]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0][12:v:0][12:a:0][13:v:0][13:a:0][14:v:0][14:a:0][15:v:0][15:a:0][16:v:0][16:a:0][17:v:0][17:a:0][18:v:0][18:a:0][19:v:0][19:a:0] concat=unsafe=1:n=20"

input_file_args[20]="-i 0.mp4 -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -i 10.mp4 -i 11.mp4 -i 12.mp4 -i 13.mp4 -i 14.mp4 -i 15.mp4 -i 16.mp4 -i 17.mp4 -i 18.mp4 -i 19.mp4 -i 20.mp4"

stream_args[20]="[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0][4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0][8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0][12:v:0][12:a:0][13:v:0][13:a:0][14:v:0][14:a:0][15:v:0][15:a:0][16:v:0][16:a:0][17:v:0][17:a:0][18:v:0][18:a:0][19:v:0][19:a:0][20:v:0][20:a:0] concat=unsafe=1:n=21"

## Concatenating Videos.

cd "$date"_finalvid

ffmpeg -loglevel quiet ${input_file_args[$file_name]} -vsync 2 -filter_complex \
     "${stream_args[$file_name]}:v=1:a=1[outv][outa]" \
    -map "[outv]" -map "[outa]" ../uploads/"$date".mp4

cd ../

## Previewing video

#question=$(dmenu -p "Preview video $date.mp4 ? (y/n)" < /dev/null)
#[ $question == 'y' ] && mpv --really-quiet uploads/$date.mp4 
#
### Uploading to youtube
#
#title=$(dmenu -p "set title" < /dev/null)
#tags=$(dmenu -p "set tags" < /dev/null)
#
#[ -z $title ] || youtube-upload \
#    --title="$title" \
#    --description="i am a bot 🤖 and i create cringe compilations from r/cringetopia" \
#    --tags="$tags" \
#    --privacy="public" \
#    uploads/$date.mp4 
#
#notify-send -u critical "video uploaded."














