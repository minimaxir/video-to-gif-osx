source ~/.bash_profile

for f in "$@"
do

	# Change this value to increase maximum size
	GIF_MAX_SIZE=480

	dir="$(dirname "$f")"
	name="$(basename "$f")"

	cd "$dir"

	video_properties=$(mplayer -really-quiet -ao null -vo null -identify -frames 0 "$f")

	video_width=$(echo $video_properties | sed -e 's/.*\ID_VIDEO_WIDTH=\([0-9]*\).*/\1/')
	video_height=$(echo $video_properties | sed -e 's/.*\ID_VIDEO_HEIGHT=\([0-9]*\).*/\1/')
	aspect_ratio=$(echo "$video_width $video_height" | awk '{printf "%.5f", $1/$2}')

	# shrink larger dimension to GIF_MAX_SIZE;
	if [ $video_height -lt $video_width ]
		then
			final_width=$GIF_MAX_SIZE
			final_height=$(echo "$final_width $aspect_ratio" | awk '{printf "%3.0f", $1/$2}')
		else
			final_height=$GIF_MAX_SIZE
			final_width=$(echo "$final_height $aspect_ratio" | awk '{printf "%3.0f", $1/(1/$2)}')
	fi

	# Don't change dimensions if both are below GIF_MAX_SIZE
	if [$video_width -lt $GIF_MAX_SIZE] && [$video_height -lt $GIF_MAX_SIZE]
	then
		final_width=$video_width
		final_height=$video_height
	fi

	mplayer -ao null -vo png:z=1:outdir=.temp -vf scale=$final_width:$final_height "$f"

	convert +repage -fuzz 1.6% -delay 1.7 -loop 0 .temp/*.png -layers OptimizePlus -layers OptimizeTransparency .temp.gif

	gifsicle -O3 --colors 256 .temp.gif > "${name%.*}.gif"
	
	# Cleanup
	rm -rf .temp
	rm -rf .temp.gif

done