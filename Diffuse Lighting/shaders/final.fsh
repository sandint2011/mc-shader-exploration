#version 120

varying vec2 TexCoords;

uniform sampler2D colortex0; // Color.

void main() {
	// Sample and apply gamma correction
   vec3 Color = pow(texture2D(colortex0, TexCoords).rgb, vec3(1.0 / 2.2));
   gl_FragColor = vec4(Color, 1.0);
}