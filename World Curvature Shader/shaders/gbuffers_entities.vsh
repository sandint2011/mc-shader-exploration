#version 120
#include "world_curvature.glsl"

varying vec2 TexCoords;
varying vec3 Normal;

uniform mat4 gbufferModelView, gbufferModelViewInverse; // Used to undo and redo MVP matrices for the purpose of world curvature calculations.

void main() {
	// Apply world curvature and set the vertex position.
	vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
	position.y -= worldCurvature(position);
	gl_Position = gl_ProjectionMatrix * gbufferModelView * position;

	TexCoords = gl_MultiTexCoord0.st; // Vec4 texture coordinate.

	// gl_Normal is built-in attribute for world-space normal vector.
	// Transform normal from world-space to view-space.
	Normal = gl_NormalMatrix * gl_Normal;
}