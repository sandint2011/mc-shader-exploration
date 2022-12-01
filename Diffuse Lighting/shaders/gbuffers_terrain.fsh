#version 120

varying vec2 LightmapCoords;
varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 BiomeColor;

uniform sampler2D texture;


void main() {
	// Sample from texture atlas, then multiply by biome color
	// (since vegatation, water, etc. are greyscale and then multiplied to be different shades of green basedon the biome).
	vec4 albedo = texture2D(texture, TexCoords) * BiomeColor;

	// Declare access to draw buffers 0 and 1,
	// using a comment because of course Minecraft would code with comments.
	// Then draw to them.
	/* DRAWBUFFERS:012 */
	gl_FragData[0] = albedo;
	gl_FragData[1] = vec4(Normal * 0.5f + 0.5f, 1.0);
	gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
}