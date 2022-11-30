#version 120

varying vec2 TexCoords;

// Direction of the sun (not normalized).
uniform vec3 sunPosition;

// The color texutre which we wrote to in `gbuffers_terrain`.
uniform sampler2D colortex0; // Albedo.
uniform sampler2D colortex1; // Normal.

// Set the out color texture formats,
// using a comment because of course Minecraft would code with comments.
/*
const int colortex0Format = RGBA16;
const int colortex1Format = RGBA16;
*/

// Optifine will read this variable.
const float sunPathRotation = -40.0; // How titled the sun path is, in degrees.

const float Ambient = 0.1;

void main() {
	// Account for gamma correction because textures have gamma already.
	vec3 Albedo = pow(texture2D(colortex0, TexCoords).rgb, vec3(2.2f));

	// Get the normal and bring it to [-1, 1] range.
	vec3 Normal = normalize(texture2D(colortex1, TexCoords).rgb * 2.0 - 1.0);

	// Computer the cosine theta between the normal and sun directions.
	float NdotL = max(dot(Normal, normalize(sunPosition)), 0.0);

	// Do the lighting calculations.
	vec3 Diffuse = Albedo * (NdotL + Ambient);

	// Declare access to draw buffers 0,
	// using a comment because of course Minecraft would code with comments.
	// Then write the diffuse color.
	/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(Diffuse, 1.0); // This will re-gamma correct in the built-in final shader pass.
}