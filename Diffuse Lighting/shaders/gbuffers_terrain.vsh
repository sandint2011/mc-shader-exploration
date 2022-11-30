#version 120

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
}