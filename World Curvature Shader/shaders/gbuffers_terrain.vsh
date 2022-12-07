#version 120

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 BiomeColor; // Water and foliage is greyscale and then colored based on the biome it is.

uniform mat4 gbufferModelView, gbufferModelViewInverse; // Used to undo and redo MVP matrices for the purpose of world curvature calculations.

float WORLD_CURVATURE_SIZE = 256;

// float worldCurvature(vec3 position) {
// 	vec3 CurvedPosition = position;
// 	//CurvedPosition.y -= dot(position.xz, position.xz) / WORLD_CURVATURE_SIZE;
// 	return CurbedPosition;
// }

void main() {
	// Apply world curvature and set the vertex position.
	vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
	position.y -= dot(position.xz, position.xz) / WORLD_CURVATURE_SIZE; // World curvature formula.
	gl_Position = gl_ProjectionMatrix * gbufferModelView * position;

	TexCoords = gl_MultiTexCoord0.st; // Vec4 texture coordinate.

	// gl_Normal is built-in attribute for world-space normal vector.
	// Transform normal from world-space to view-space.
	Normal = gl_NormalMatrix * gl_Normal;
	BiomeColor = gl_Color;
}