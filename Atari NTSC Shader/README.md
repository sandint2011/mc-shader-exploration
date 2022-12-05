# Atari NTSC Shader

This shader overrides the final pass to make the game look like an old Atari 2600 screen, witht the NTSC format. It accomplishes this by doing 3 things:

1. The shader limits the color output to the 128 colors, from the Atari NTSC color format, just like the old Atari screens.
	* This is done by using the distance formula on each fragment color against each color in the palette.
	* Color codes were pulled from this [List of Video Game Console Palettes](https://en.wikipedia.org/wiki/list_of_video_game_console_palettes#NTSC) Wikipedia page.
3. The shader pixelates the screen so pixels are 4x the size, in order to emulate the low-resolution Gameboy screen and to make the dithering effect more apparent.
