#version 130

out vec2 screenCoord;

void main(){
    screenCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    gl_Position = ftransform();
}