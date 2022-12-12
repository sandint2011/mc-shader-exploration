#version 130

varying vec2 screenCoord;
varying vec3 screenRay;
varying float LdotV;


// Shadow light position in view space
uniform vec3 shadowLightPosition;
// Converts view space to clip space
uniform mat4 gbufferProjection;

vec3 toScreen(vec3 pos){
	vec3 data = vec3(gbufferProjection[0].x, gbufferProjection[1].y, gbufferProjection[2].z) * pos + gbufferProjection[3].xyz;
	return (data.xyz / -pos.z) * 0.5 + 0.5;
}

void main(){
    screenCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    // The ray direction (or light direction)
    // Because it's already in view space, we need not to do anything fancy yet and just normalize
    screenRay = toScreen(normalize(shadowLightPosition));
    LdotV = -normalize(shadowLightPosition).z;
    gl_Position = ftransform();


}