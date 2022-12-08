#version 120

varying vec2 TexCoords;

void main() {
	gl_Position = ftransform(); // Essentially gl_ModelViewProjectionMatrix * gl_Vertex.
	TexCoords = gl_MultiTexCoord0.st; // Vec4 texture coordinate.
}