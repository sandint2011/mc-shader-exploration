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

// NES's 54 colors (technically the palette had 64, but there were 2 identical whites and 10 identical blacks for some reason).
const vec3[54] NES_COLORS = {
	// White to grey to black.
	vec3(254, 254, 254) / vec3(255),
	vec3(184, 184, 184) / vec3(255),
	vec3(174, 174, 174) / vec3(255),
	vec3(102, 102, 102) / vec3(255),
	vec3(79, 79, 79) / vec3(255),
	vec3(0, 0, 0) / vec3(255),
	// Red (light to dark).
	vec3(254, 205, 198) / vec3(255),
	vec3(254, 130, 112) / vec3(255),
	vec3(181, 50, 32) / vec3(255),
	vec3(108, 7, 0) / vec3(255),
	// Orange (light to dark).
	vec3(247, 217, 166) / vec3(255),
	vec3(235, 159, 33) / vec3(255),
	vec3(153, 79, 0) / vec3(255),
	vec3(87, 29, 0) / vec3(255),
	// Yellow (light to dark).
	vec3(229, 230, 149) / vec3(255),
	vec3(189, 191, 0) / vec3(255),
	vec3(108, 110, 0) / vec3(255),
	vec3(52, 53, 0) / vec3(255),
	// Lime (light to dark).
	vec3(208, 240, 151) / vec3(255),
	vec3(137, 217, 0) / vec3(255),
	vec3(56, 135, 0) / vec3(255),
	vec3(12, 73, 0) / vec3(255),
	// Green (light to dark).
	vec3(190, 245, 171) / vec3(255),
	vec3(93, 229, 48) / vec3(255),
	vec3(13, 148, 0) / vec3(255),
	vec3(0, 82, 0) / vec3(255),
	// Teal (light to dark).
	vec3(180, 243, 205) / vec3(255),
	vec3(69, 225, 130) / vec3(255),
	vec3(0, 144, 50) / vec3(255),
	vec3(0, 79, 8) / vec3(255),
	// Cyan (light to dark).
	vec3(181, 236, 243) / vec3(255),
	vec3(72, 206, 223) / vec3(255),
	vec3(0, 124, 142) / vec3(255),
	vec3(0, 64, 78) / vec3(255),
	// Blue (light to dark).
	vec3(193, 224, 254) / vec3(255),
	vec3(100, 176, 254) / vec3(255),
	vec3(21, 95, 218) / vec3(255),
	vec3(0, 42, 136) / vec3(255),
	// Indigo (light to dark).
	vec3(212, 211, 254) / vec3(255),
	vec3(147, 144, 254) / vec3(255),
	vec3(66, 64, 254) / vec3(255),
	vec3(20, 18, 168) / vec3(255),
	// Purple (light to dark).
	vec3(233, 200, 254) / vec3(255),
	vec3(199, 119, 254) / vec3(255),
	vec3(118, 39, 255) / vec3(255),
	vec3(59, 0, 164) / vec3(255),
	// Magenta (light to dark).
	vec3(251, 195, 254) / vec3(255),
	vec3(243, 106, 254) / vec3(255),
	vec3(161, 27, 205) / vec3(255),
	vec3(92, 0, 126) / vec3(255),
	// Pink (light to dark).
	vec3(254, 197, 235) / vec3(255),
	vec3(254, 110, 205) / vec3(255),
	vec3(184, 30, 124) / vec3(255),
	vec3(110, 0, 64) / vec3(255)
};

// Pixelation scale (1 is normal, 2 is double, 4 is quadruple, etc.).
const int PIXEL_SCALE = 4;

// Take an input color and output the closest NES color,
// essentially limiting screen colors to the 54 NES palette colors.
vec3 closestColor(vec3 color) {
	vec3 ClosestColor = NES_COLORS[0];
	float ShortestDistance = 1000.0;
	for (int i = 0; i < 54; i++) {
		float Distance = distance(color, NES_COLORS[i]);
		if (Distance < ShortestDistance) {
			ShortestDistance = Distance;
			ClosestColor = NES_COLORS[i];
		}
	}
	return ClosestColor;
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

	// Pick the closest color in the NES color palette.
	Color = closestColor(Color);

	// Output the green color.
	gl_FragColor = vec4(Color, 1.0f);
}