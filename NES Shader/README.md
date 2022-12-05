# NES Shader

This shader overrides the final pass to make the game look like an old Gameboy screen. It accomplishes this by doing 3 things:

1. The shader limits the color output to 4 colors, each a shade of green, just like the old Gameboy screens.
	* Color codes were pulled from the [Gameboy Wikipedia](https://en.wikipedia.org/wiki/Game_Boy) page.
2. The shader technically computes 7 colors. There are the 4 solid colors, and 3 intermediate colors that are [dithered](https://en.wikipedia.org/wiki/Dither) between the two neighborind colors.
3. The shader pixelates the screen so pixels are 3x the size, in order to emulate the low-resolution Gameboy screen and to make the dithering effect more apparent.
