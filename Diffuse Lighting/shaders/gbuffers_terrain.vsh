#version 120

varying vec2 LightmapCoords;
varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 BiomeColor;

void main() {
	gl_Position = ftransform();
	TexCoords = gl_MultiTexCoord0.st;

	// gl_Normal is built-in attribute for world-space normal vector.
	// Transform normal from world-space to view-space.
	Normal = gl_NormalMatrix * gl_Normal;
	BiomeColor = gl_Color;

	//Use the texture matrix instead of dividing by 15 to maintain campataility for each version of Minecraft
	LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
	//Transform them into [0,1] range
	LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
}