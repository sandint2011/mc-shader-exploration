#version 120

varying vec2 TexCoords;

uniform sampler2D colortex0; // Optifine's internal shader output (reimplementation of default MC shaders in Optifine's shader pipeline).

void main() {
	// Sample the color.
	vec3 Color = texture2D(colortex0, TexCoords).rgb;

	// Convert to grayscale.
	Color = vec3(dot(Color, vec3(0.333f)));

	// Output the color.
	gl_FragColor = vec4(Color, 1.0f);
}