#version 120

varying vec2 TexCoords;

uniform sampler2D colortex0; // Optifine's internal shader output (reimplementation of default MC shaders in Optifine's shader pipeline).

uniform float viewWidth;
uniform float viewHeight;

// ATARI 2600 NTSC format's 128 colors.
vec3[128] ATARI_COLORS;
ATARI_COLORS[0] = vec3(0, 0, 0) / vec3(255);
ATARI_COLORS[1] = vec3(108, 108, 108) / vec3(255);
ATARI_COLORS[2] = vec3(144, 144, 144) / vec3(255);
ATARI_COLORS[3] = vec3(176, 176, 176) / vec3(255);
ATARI_COLORS[4] = vec3(200, 200, 200) / vec3(255);
ATARI_COLORS[5] = vec3(220, 220, 220) / vec3(255);
ATARI_COLORS[6] = vec3(236, 236, 236) / vec3(255);
ATARI_COLORS[7] = vec3(255, 255, 255) / vec3(255);
ATARI_COLORS[8] = vec3(68, 68, 0) / vec3(255);
ATARI_COLORS[9] = vec3(112, 40, 0) / vec3(255);
ATARI_COLORS[10] = vec3(132, 24, 0) / vec3(255);
ATARI_COLORS[11] = vec3(136, 0, 0) / vec3(255);
ATARI_COLORS[12] = vec3(120, 0, 92) / vec3(255);
ATARI_COLORS[13] = vec3(72, 0, 120) / vec3(255);
ATARI_COLORS[14] = vec3(20, 0, 132) / vec3(255);
ATARI_COLORS[15] = vec3(0, 0, 136) / vec3(255);
ATARI_COLORS[16] = vec3(0, 24, 124) / vec3(255);
ATARI_COLORS[17] = vec3(0, 44, 92) / vec3(255);
ATARI_COLORS[18] = vec3(0, 64, 44) / vec3(255);
ATARI_COLORS[19] = vec3(0, 60, 0) / vec3(255);
ATARI_COLORS[20] = vec3(20, 56, 0) / vec3(255);
ATARI_COLORS[21] = vec3(44, 48, 0) / vec3(255);
ATARI_COLORS[22] = vec3(68, 40, 0) / vec3(255);
ATARI_COLORS[23] = vec3(64, 64, 64) / vec3(255);
ATARI_COLORS[24] = vec3(100, 100, 16) / vec3(255);
ATARI_COLORS[25] = vec3(132, 68, 20) / vec3(255);
ATARI_COLORS[26] = vec3(152, 52, 24) / vec3(255);
ATARI_COLORS[27] = vec3(156, 32, 32) / vec3(255);
ATARI_COLORS[28] = vec3(140, 32, 116) / vec3(255);
ATARI_COLORS[29] = vec3(96, 32, 144) / vec3(255);
ATARI_COLORS[30] = vec3(48, 32, 152) / vec3(255);
ATARI_COLORS[31] = vec3(28, 32, 156) / vec3(255);
ATARI_COLORS[32] = vec3(28, 56, 144) / vec3(255);
ATARI_COLORS[33] = vec3(28, 76, 120) / vec3(255);
ATARI_COLORS[34] = vec3(28, 92, 72) / vec3(255);
ATARI_COLORS[35] = vec3(32, 92, 32) / vec3(255);
ATARI_COLORS[36] = vec3(52, 92, 28) / vec3(255);
ATARI_COLORS[37] = vec3(76, 80, 28) / vec3(255);
ATARI_COLORS[38] = vec3(100, 72, 24) / vec3(255);
ATARI_COLORS[39] = vec3(132, 132, 36) / vec3(255);
ATARI_COLORS[40] = vec3(152, 92, 40) / vec3(255);
ATARI_COLORS[41] = vec3(172, 80, 48) / vec3(255);
ATARI_COLORS[42] = vec3(176, 60, 60) / vec3(255);
ATARI_COLORS[43] = vec3(160, 60, 136) / vec3(255);
ATARI_COLORS[44] = vec3(120, 60, 164) / vec3(255);
ATARI_COLORS[45] = vec3(76, 60, 172) / vec3(255);
ATARI_COLORS[46] = vec3(56, 64, 176) / vec3(255);
ATARI_COLORS[47] = vec3(56, 84, 168) / vec3(255);
ATARI_COLORS[48] = vec3(56, 104, 144) / vec3(255);
ATARI_COLORS[49] = vec3(56, 124, 100) / vec3(255);
ATARI_COLORS[50] = vec3(64, 124, 64) / vec3(255);
ATARI_COLORS[51] = vec3(80, 124, 56) / vec3(255);
ATARI_COLORS[52] = vec3(104, 112, 52) / vec3(255);
ATARI_COLORS[53] = vec3(132, 104, 48) / vec3(255);
ATARI_COLORS[54] = vec3(160, 160, 52) / vec3(255);
ATARI_COLORS[55] = vec3(172, 120, 60) / vec3(255);
ATARI_COLORS[56] = vec3(192, 104, 72) / vec3(255);
ATARI_COLORS[57] = vec3(192, 88, 88) / vec3(255);
ATARI_COLORS[58] = vec3(176, 88, 156) / vec3(255);
ATARI_COLORS[59] = vec3(140, 88, 184) / vec3(255);
ATARI_COLORS[60] = vec3(104, 88, 192) / vec3(255);
ATARI_COLORS[61] = vec3(80, 92, 192) / vec3(255);
ATARI_COLORS[62] = vec3(80, 112, 188) / vec3(255);
ATARI_COLORS[63] = vec3(80, 132, 172) / vec3(255);
ATARI_COLORS[64] = vec3(80, 156, 128) / vec3(255);
ATARI_COLORS[65] = vec3(92, 156, 92) / vec3(255);
ATARI_COLORS[66] = vec3(108, 152, 80) / vec3(255);
ATARI_COLORS[67] = vec3(132, 140, 76) / vec3(255);
ATARI_COLORS[68] = vec3(160, 132, 68) / vec3(255);
ATARI_COLORS[69] = vec3(184, 184, 64) / vec3(255);
ATARI_COLORS[70] = vec3(188, 140, 76) / vec3(255);
ATARI_COLORS[71] = vec3(208, 128, 92) / vec3(255);
ATARI_COLORS[72] = vec3(208, 112, 112) / vec3(255);
ATARI_COLORS[73] = vec3(192, 112, 176) / vec3(255);
ATARI_COLORS[74] = vec3(160, 112, 204) / vec3(255);
ATARI_COLORS[75] = vec3(124, 112, 208) / vec3(255);
ATARI_COLORS[76] = vec3(104, 116, 208) / vec3(255);
ATARI_COLORS[77] = vec3(104, 136, 204) / vec3(255);
ATARI_COLORS[78] = vec3(104, 156, 192) / vec3(255);
ATARI_COLORS[79] = vec3(104, 180, 148) / vec3(255);
ATARI_COLORS[80] = vec3(116, 180, 116) / vec3(255);
ATARI_COLORS[81] = vec3(132, 180, 104) / vec3(255);
ATARI_COLORS[82] = vec3(156, 168, 100) / vec3(255);
ATARI_COLORS[83] = vec3(184, 156, 88) / vec3(255);
ATARI_COLORS[84] = vec3(208, 208, 80) / vec3(255);
ATARI_COLORS[85] = vec3(204, 160, 92) / vec3(255);
ATARI_COLORS[86] = vec3(224, 148, 112) / vec3(255);
ATARI_COLORS[87] = vec3(224, 135, 135) / vec3(255);
ATARI_COLORS[88] = vec3(208, 132, 192) / vec3(255);
ATARI_COLORS[89] = vec3(180, 132, 220) / vec3(255);
ATARI_COLORS[90] = vec3(148, 136, 224) / vec3(255);
ATARI_COLORS[91] = vec3(124, 140, 224) / vec3(255);
ATARI_COLORS[92] = vec3(124, 156, 220) / vec3(255);
ATARI_COLORS[93] = vec3(124, 180, 212) / vec3(255);
ATARI_COLORS[94] = vec3(124, 208, 172) / vec3(255);
ATARI_COLORS[95] = vec3(140, 208, 140) / vec3(255);
ATARI_COLORS[96] = vec3(156, 204, 124) / vec3(255);
ATARI_COLORS[97] = vec3(180, 192, 120) / vec3(255);
ATARI_COLORS[98] = vec3(208, 180, 108) / vec3(255);
ATARI_COLORS[99] = vec3(232, 232, 92) / vec3(255);
ATARI_COLORS[100] = vec3(220, 180, 104) / vec3(255);
ATARI_COLORS[101] = vec3(236, 168, 128) / vec3(255);
ATARI_COLORS[102] = vec3(236, 160, 160) / vec3(255);
ATARI_COLORS[103] = vec3(220, 156, 208) / vec3(255);
ATARI_COLORS[104] = vec3(196, 156, 236) / vec3(255);
ATARI_COLORS[105] = vec3(168, 160, 236) / vec3(255);
ATARI_COLORS[106] = vec3(144, 164, 236) / vec3(255);
ATARI_COLORS[107] = vec3(144, 180, 236) / vec3(255);
ATARI_COLORS[108] = vec3(144, 204, 232) / vec3(255);
ATARI_COLORS[109] = vec3(144, 228, 192) / vec3(255);
ATARI_COLORS[110] = vec3(164, 228, 164) / vec3(255);
ATARI_COLORS[111] = vec3(180, 228, 144) / vec3(255);
ATARI_COLORS[112] = vec3(204, 212, 136) / vec3(255);
ATARI_COLORS[113] = vec3(232, 204, 124) / vec3(255);
ATARI_COLORS[114] = vec3(252, 252, 104) / vec3(255);
ATARI_COLORS[115] = vec3(252, 188, 148) / vec3(255);
ATARI_COLORS[116] = vec3(252, 180, 180) / vec3(255);
ATARI_COLORS[117] = vec3(236, 176, 224) / vec3(255);
ATARI_COLORS[118] = vec3(212, 176, 252) / vec3(255);
ATARI_COLORS[119] = vec3(188, 180, 252) / vec3(255);
ATARI_COLORS[120] = vec3(164, 184, 252) / vec3(255);
ATARI_COLORS[121] = vec3(164, 200, 252) / vec3(255);
ATARI_COLORS[122] = vec3(164, 224, 252) / vec3(255);
ATARI_COLORS[123] = vec3(164, 252, 212) / vec3(255);
ATARI_COLORS[124] = vec3(184, 252, 184) / vec3(255);
ATARI_COLORS[125] = vec3(200, 252, 164) / vec3(255);
ATARI_COLORS[126] = vec3(224, 236, 156) / vec3(255);
ATARI_COLORS[127] = vec3(252, 224, 140) / vec3(255);

// Pixelation scale (1 is normal, 2 is double, 4 is quadruple, etc.).
const int PIXEL_SCALE = 4;

// Take an input color and output the closest NES color,
// essentially limiting screen colors to the 54 NES palette colors.
vec3 closestColor(vec3 color) {
	vec3 ClosestColor = ATARI_COLORS[0];
	float ShortestDistance = 1000.0;
	for (int i = 0; i < 128; i++) {
		float Distance = distance(color, ATARI_COLORS[i]);
		//float Distance = length(dot(color - ATARI_COLORS[i], color - ATARI_COLORS[i])); // Identical to above (same performance too).
		if (Distance < ShortestDistance) {
			ShortestDistance = Distance;
			ClosestColor = ATARI_COLORS[i];
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

	// Pick the closest color in the NES color palette.
	Color = closestColor(Color);

	// Output the green color.
	gl_FragColor = vec4(Color, 1.0);
}