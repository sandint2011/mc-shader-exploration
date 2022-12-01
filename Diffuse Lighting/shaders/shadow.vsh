#version 120

void main(){
	gl_Position = ftransform(); // Essentially gl_ModelViewProjectionMatrix * gl_Vertex.
}