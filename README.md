# Convert Video to GIF on OSX

This repository contains a set of utilities that allow the user to easily convert video files to high-quality, low file size GIFs on OS X. This post is a complement to my blog post [Making a Video-to-GIF Right-Click Menu Item in OS X](http://minimaxir.com/2015/08/gif-to-video-osx/)

The tool comes in three forms, depending on user needs:

* **Convert Video to GIF** - A OS X Service which adds a "Convert Video to GIF" right-click menu item to all video files, which outputs a GIF of the video in the same folder of the source(s).
* **osx_video_to_gif.sh** - A Shell script which accepts video(s) as parameter(s) and outputs a GIF of the video in the same folder of the source(s).
* **Convert Video to GIF App** - An Application which prompts the user for video(s) and outputs a GIF of the video in the same folder of the source(s).

## Installation

*Note: Installation may have issues depending on system config, particularly step #2. If you run into issues, let me know.*

1. Open up Terminal and install [Homebrew](http://brew.sh) by running this command and following the instructions:

		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		
2. Install the three GIF-making applications using this Homebrew command:

		brew install ImageMagick mplayer gifsicle

3. Download the tool of choice. To install the Convert Video to GIF Service, download and double-click.

## Notes

All forms have a max GIF width of 480px; this is a value chosen to both manage file size and compatability with all applications. If you wish to create larger GIFs, open up the tool and change the value of `GIF_MAX_SIZE` at the beginning of the file.

## Known Issues

* If the video has unusual dimensions (e.g. 7.00 aspect ratio), the GIF output will not be resized correctly. (in fairness, you probably do not want a GIF with an unusual aspect ratio)
* If the video file or the parent directory has spaces, the tool may throw errors.

## Maintainer
* Max Woolf [(@minimaxir)](https://twitter.com/minimaxir)
