# NES Shader

This shader overrides the final pass to make the game look like an old NES screen. It accomplishes this by doing 3 things:

1. The shader limits the color output to the 54 colors, from the NES color palette, just like the old NES screens.
	* This is done by using the distance formula on each fragment color against each color in the palette.
	* Color codes were pulled from this [List of Video Game Console Palettes](https://en.wikipedia.org/wiki/list_of_video_game_console_palettes#NES) Wikipedia page.
3. The shader pixelates the screen so pixels are 4x the size, in order to emulate the low-resolution Gameboy screen and to make the dithering effect more apparent.
