#version 120

varying vec2 TexCoords;

uniform sampler2D colortex0; // Optifine's internal shader output (reimplementation of default MC shaders in Optifine's shader pipeline).

uniform float viewWidth;
uniform float viewHeight;

// Gameboy's 4 green color values.
// Haven't learned how to add custom uniforms yet, so they're hardcoded.
const vec3 GAMEBOY_0 = vec3(15, 56, 15) / vec3(255);
const vec3 GAMEBOY_1 = vec3(48, 98, 48) / vec3(255);
const vec3 GAMEBOY_2 = vec3(139, 172, 15) / vec3(255);
const vec3 GAMEBOY_3 = vec3(155, 188, 15) / vec3(255);

// Pixelation scale (1 is normal, 2 is double, 4 is quadruple, etc.).
const int PIXEL_SCALE = 3;

// When doing dithering between 2 colors, this decides which one to pick.
vec3 dither(int x, int y, vec3 color1, vec3 color2) {
	bool DoDither = (x/PIXEL_SCALE % 2 == 0 && y/PIXEL_SCALE % 2 != 0) || (y/PIXEL_SCALE % 2 == 0 && x/PIXEL_SCALE % 2 != 0);
	if (DoDither) {
		return color1;
	}
	return color2;
}

void main() {
	// Pixelate the screen by a4 so pixels look larger (makes dithering more noticeable and the screen more like an old pixelated gameboy screen).
	vec2 PixelatedTexCoords = vec2(TexCoords.x, TexCoords.y);
	// The following few lines are a long way of modulating, since GLSL v2.1 has problems with mod() or % when floats are involved.
	// Convert texture coordinates to screen pixel coordinates, and floor them (just in case).
	int PX = int(PixelatedTexCoords.x * viewWidth / PIXEL_SCALE);
	int PY = int(PixelatedTexCoords.y * viewHeight / PIXEL_SCALE);
	// Convert pixel coordinates back up to texture coordinates (essentially modulating).
	PixelatedTexCoords.x = PX / viewWidth * PIXEL_SCALE;
	PixelatedTexCoords.y = PY / viewHeight * PIXEL_SCALE;

	// Sample the color.
	vec3 Color = texture2D(colortex0, PixelatedTexCoords).rgb;

	// Convert to grayscale.
	Color = vec3(dot(Color, vec3(0.333f)));

	// Get the pixel coordinate (for dithering). Bottom-left is (0,0).
	// This doesn't use pixelated texture coordinates, because it causes artifacts, so it's handled in the doDither() function to compensate.
	vec2 Pixel = vec2(TexCoords.x * viewWidth, TexCoords.y * viewHeight);
	int PixelX = int(floor(Pixel.x));
	int PixelY = int(floor(Pixel.y));

	// Pick from 4 green colors or 3 intermediate dither colors, based on color value.
	vec3 Green;
	// Green 0.
	if (Color.g < 1.0 / 7.0) {
		Green = GAMEBOY_0;
	// Green 0-1 (dither).
	} else if (Color.g < 2.0 / 7.0) {
		Green = dither(PixelX, PixelY, GAMEBOY_0, GAMEBOY_1);
	// Green 1.
	} else if (Color.g < 3.0 / 7.0) {
		Green = GAMEBOY_1;
	// Green 1-2 (dither).
	} else if (Color.g < 4.0 / 7.0) {
		Green = dither(PixelX, PixelY, GAMEBOY_1, GAMEBOY_2);
	// Green 2.
	} else if (Color.g < 5.0 / 7.0) {
		Green = GAMEBOY_2;
	// Green 2-3 (dither). 
	} else if (Color.g < 6.0 / 7.0) {
		Green = dither(PixelX, PixelY, GAMEBOY_2, GAMEBOY_3);
	// Green 3.
	} else {
		Green = GAMEBOY_3;
	}

	// Output the green color.
	gl_FragColor = vec4(Green, 1.0f);
}