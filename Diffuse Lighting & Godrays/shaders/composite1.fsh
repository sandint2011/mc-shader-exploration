#version 130

varying vec2 screenCoord;
varying vec3 screenRay;
varying float LdotV;

// Default noise resolution, needs to exist for Optifine to detect and use our noise texture
const int noiseTextureResolution = 256;

uniform sampler2D gcolor;
uniform sampler2D noisetex;
uniform sampler2D depthtex1;

// Projection matrix
// Converts view space to clip space
uniform mat4 gbufferProjection;

// Shadow light position in view space
uniform vec3 shadowLightPosition;

// Sky mask detector, with brightness input
float skyMask(in vec2 uv, in float brightness){
    // Detects sky by checking if it's equal to 1.0 and return brightness
    // Switch to depthtex0 if you want godrays to not go "through" transparent objects
    if(textureLod(depthtex1, uv, 0).x == 1.0) return brightness;
    // Otherwise return 0.0
    return 0.0;
}



void main(){
    // Screen texel coords
    ivec2 screenTexelCoord = ivec2(gl_FragCoord.xy);
    // Sample main scene color
    vec3 sceneCol = texelFetch(gcolor, screenTexelCoord, 0).rgb;
    // Sample blue noise
    float blueNoise = texelFetch(noisetex, screenTexelCoord & 255, 0).x;


    // The amount of steps/samples used
    // More means more quality and more slower
    const int stepSize = 16;
    // Reciprocate of step size (1.0 / stepSize)
    const float rcpStepSize = 1.0 / float(stepSize);

    // Godray length
    const float rayLength = 1;
    // Godray strength
    const float rayStrength = rcpStepSize / 5;
    // Light color
    const vec3 lightColor = vec3(1.0, 1.0, 0.75);

    // The end position
    // Basically the rayDir converted to screen space, subtracted from screen coord, and divided by step size and multiplied by ray length
    vec2 endPos = (screenCoord - screenRay.xy) * rcpStepSize * rayLength;
    // The start position
    // We apply dithering by multiplying end pos with blue noise and add it to our start pos
    vec2 startPos = screenCoord - endPos * blueNoise;

    // We sum and average the final result here
    float godRays = 0.0;

    for(int i = 0; i < stepSize; i++){
        // Sample sky mask
        godRays += skyMask(startPos, rayStrength);
        // We trace in the direction of endPos
        // We do this each loop
        startPos -= endPos;
    }

    // Multiply by light color and add to scene color
    sceneCol += godRays * lightColor * LdotV;

/* DRAWBUFFERS:0 */
    // Output final results to main buffer
    // This returns the colors and the alpha of the rays
    gl_FragData[0] = vec4(sceneCol, 1);
}