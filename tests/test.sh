rm test_result.txt
touch test_result.txt

echo "Programs installed:" >> test_result.txt
brew ls --versions mplayer ImageMagick gifsicle >> test_result.txt

source ~/.bash_profile

for f in "$@"
do

	# Change this value to increase maximum size
	GIF_MAX_SIZE=480

	dir="$(dirname "$f")"
	echo "\nDirectory: $dir" >> test_result.txt
	
	name="$(basename "$f")"
	echo "File Name: $name\n" >> test_result.txt
	

	cd "$dir"

	video_properties=$(mplayer -really-quiet -ao null -vo null -identify -frames 0 "$f")
	#echo "Parsed Video Properties.\n" >> test_result.txt

	video_width=$(echo $video_properties | sed -e 's/.*\ID_VIDEO_WIDTH=\([0-9]*\).*/\1/')
	video_height=$(echo $video_properties | sed -e 's/.*\ID_VIDEO_HEIGHT=\([0-9]*\).*/\1/')
	aspect_ratio=$(echo "$video_width $video_height" | awk '{printf "%.5f", $1/$2}')
	
	echo "Video Width: $video_width" >> test_result.txt
	echo "Video Height: $video_height" >> test_result.txt
	echo "Aspect Ratio: $aspect_ratio\n" >> test_result.txt

	# shrink larger dimension to GIF_MAX_SIZE;
	if [ $video_height -lt $video_width ]
		then
			final_width=$GIF_MAX_SIZE
			final_height=$(echo "$final_width $aspect_ratio" | awk '{printf "%3.0f", $1/$2}')
		else
			final_height=$GIF_MAX_SIZE
			final_width=$(echo "$final_height $aspect_ratio" | awk '{printf "%3.0f", $1/(1/$2)}')
	fi
	
	echo "Final Width: $final_width" >> test_result.txt
	echo "Final Height: $final_height\n" >> test_result.txt

	# Don't change dimensions if both are below GIF_MAX_SIZE
	if [$video_width -lt $GIF_MAX_SIZE] && [$video_height -lt $GIF_MAX_SIZE]
	then
		final_width=$video_width
		final_height=$video_height
	fi

	mplayer -ao null -vo png:z=1:outdir=.temp -vf scale=$final_width:$final_height "$f"
	
	num_renders=$(ls -l .temp | wc -l)
	#echo "mplayer renders successful." >> test_result.txt
	echo "mplayer number of video frames: $num_renders.\n" >> test_result.txt

	convert +repage -fuzz 1.6% -delay 1.7 -loop 0 .temp/*.png -layers OptimizePlus -layers OptimizeTransparency .temp.gif
	
	file_size_imagemagick=$(wc -c .temp.gif)
	#echo "ImageMagick convert successful." >> test_result.txt
	echo "ImageMagick convert file size: $file_size_imagemagick\n" >> test_result.txt

	gifsicle -O3 --colors 256 .temp.gif > "${name%.*}.gif"
	
	file_size_gifsicle=$(wc -c "${name%.*}.gif")
	#echo "gifsicle optimization successful." >> test_result.txt
	echo "gifsicle optimization file size: $file_size_gifsicle\n" >> test_result.txt
	
	# Cleanup
	rm -rf .temp
	rm -rf .temp.gif

done