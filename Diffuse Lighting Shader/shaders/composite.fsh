#version 120
#include "distort.glsl"

varying vec2 TexCoords;

// Direction of the sun (not normalized).
uniform vec3 sunPosition;

// The color textures which we write to or read from:
uniform sampler2D colortex0; // Color.
uniform sampler2D colortex1; // Normal.
uniform sampler2D colortex2; // Lighting (Red channel is block light like torches, blue channel is sky light affected by the day-night cycle).
uniform sampler2D depthtex0; // Depth from player's perspective (used for shadows).
uniform sampler2D shadowtex0; // Shadow (transparent blocks are opaque).
uniform sampler2D shadowtex1; // Shadow (transparent blocks are actually transparent).
uniform sampler2D shadowcolor0; // Shadow color (for colored and transparent shadows like glass or water).
uniform sampler2D noisetex; // Noise texture.

// Optifine uniforms for refining and blurring the shadows.
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

// These are comments, but they actually run (idk why Minecraft shaders code with comments sometimes but it's a think apparently).
// Anyway, these declare the color texture formats for Color, Normal, and Lighting.
/*
const int colortex0Format = RGBA16F;
const int colortex1Format = RGB16;
const int colortex2Format = RGB16;
*/

const float sunPathRotation = -40.0; // The angle of the sun for casting light and shadows.
const int shadowMapResolution = 1024; // The resolution we'd like to use for shadows (higher looks better but is more costly).
const int noiseTextureResolution = 128; // Default value is 64.

// Ambient lighting value.
const float Ambient = 0.025;

// Colors of the torch and sky light.
// The sky color should change depending on time of day, but is ignored for now for simplicity's sake.
const vec3 TorchColor = vec3(1.0, 0.25, 0.08);
const vec3 SkyColor = vec3(0.05, 0.15, 0.3);

// Tweak torch lighting values,
// (almost exactly like gamma correction since without this the values are linear and look bad).
float AdjustLightmapTorch(in float torch) {
	// Unsure why these values are what they are, as the tutorial didn't explain them.
	// Must be some magic numbers like 2.2 is for gamma.
	const float K = 2.0;
	const float P = 5.06;
	return K * pow(torch, P);
}

// Tweak sky lighting values,
// (almost exactly like gamma correction since without this the values are linear and look bad).
float AdjustLightmapSky(in float sky) {
	float SkySquared = pow(sky, 2);
	return pow(SkySquared, 2);
}

// Tweak all lighting (torch and sky) values,
// (almost exactly like gamma correction since without this the values are linear and look bad).
vec2 AdjustLightmap(in vec2 Lightmap) {
	vec2 NewLightMap;
	NewLightMap.x = AdjustLightmapTorch(Lightmap.x);
	NewLightMap.y = AdjustLightmapSky(Lightmap.y);
	return NewLightMap;
}

// Input is the unadjusted lightmap coordinates, as this does the adjustments for you.
vec3 GetLightmapColor(in vec2 Lightmap) {
	// First adjust the lightmap similar to gamma correction (linear looks bad basically).
	Lightmap = AdjustLightmap(Lightmap);

	// Multiply each part of the light map with it's color.
	vec3 TorchLighting = Lightmap.x * TorchColor;
	vec3 SkyLighting = Lightmap.y * SkyColor;

	// Add the lighting togther to get the total contribution of the lightmap the final color.
	vec3 LightmapLighting = TorchLighting + SkyLighting;
	return LightmapLighting;
}

// Get the visibility level of the shadow (i.e. opaque shadows or transparent like with glass).
float Visibility(in sampler2D ShadowMap, in vec3 SampleCoords) {
	// -0.001 to fix weird artifacts.
    return step(SampleCoords.z - 0.001, texture2D(ShadowMap, SampleCoords.xy).r);
}

// Check the fully-opaque shadow map and the one that supports transparency,
// then combine them to get shadows with transparency if necessary.
vec3 TransparentShadow(in vec3 SampleCoords){
    float ShadowVisibility0 = Visibility(shadowtex0, SampleCoords); // Opaque shadow map.
    float ShadowVisibility1 = Visibility(shadowtex1, SampleCoords); // Transparency shadow map.
    vec4 ShadowColor0 = texture2D(shadowcolor0, SampleCoords.xy); // Shadow color (i.e. colored glass).
    vec3 TransmittedColor = ShadowColor0.rgb * (1.0 - ShadowColor0.a); // Perform a blend operation with the sun color.
    return mix(TransmittedColor * ShadowVisibility1, vec3(1.0), ShadowVisibility0); // Finally, combine all the shadow information together.
}

// Some constants for GetShadow() for shadow sample resolution.
#define SHADOW_SAMPLES 2
const int ShadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
const int TotalSamples = ShadowSamplesPerSize * ShadowSamplesPerSize;


// Get the shadow based on depth (this handles conversion between spaces and transformations and stuff).
vec3 GetShadow(float depth) {
	// Do some space and projection conversions for the shadows.
    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0 - 1.0;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0);
    vec4 ShadowSpace = shadowProjection * shadowModelView * World;
    ShadowSpace.xy = DistortPosition(ShadowSpace.xy);
    vec3 SampleCoords = ShadowSpace.xyz * 0.5 + 0.5;
    
	// Handle adding noise to the shadow to fix level/line artifacts.
	float RandomAngle = texture2D(noisetex, TexCoords * 20.0).r * 100.0;
    float cosTheta = cos(RandomAngle);
	float sinTheta = sin(RandomAngle);
    mat2 Rotation =  mat2(cosTheta, -sinTheta, sinTheta, cosTheta) / shadowMapResolution; // We can move our division by the shadow map resolution here for a small speedup
    vec3 ShadowAccum = vec3(0.0);
    
	// Loop through shadow samples and apply the blurring and noise effects.
	for(int x = -SHADOW_SAMPLES; x <= SHADOW_SAMPLES; x++){
        for(int y = -SHADOW_SAMPLES; y <= SHADOW_SAMPLES; y++){
            vec2 Offset = Rotation * vec2(x, y);
            vec3 CurrentSampleCoordinate = vec3(SampleCoords.xy + Offset, SampleCoords.z);
            ShadowAccum += TransparentShadow(CurrentSampleCoordinate);
        }
    }
    ShadowAccum /= TotalSamples;
    return ShadowAccum;
}

void main() {
	// Account for gamma correction, since block textures are already gamma encoded.
	vec3 Albedo = pow(texture2D(colortex0, TexCoords).rgb, vec3(2.2));
	float Depth = texture2D(depthtex0, TexCoords).r;

	// Sky depth is always 1.0, so end early if it's a sky fragment to skip block calculations.
	if (Depth == 1.0) {
		gl_FragData[0] = vec4(Albedo, 1.0);
		return;
	}

	// Get the normal.
	vec3 Normal = normalize(texture2D(colortex1, TexCoords).rgb * 2.0 - 1.0);

	// Get the lightmap.
	vec2 Lightmap = texture2D(colortex2, TexCoords).rg; // R is torch light and G is sky light.
	vec3 LightmapColor = GetLightmapColor(Lightmap);

	// Compute cosine-theta between the normal and sun directions.
	float NdotL = max(dot(Normal, normalize(sunPosition)), 0.0);

	// Do the lighting calculations to get the final diffuse color.
	vec3 Diffuse = Albedo * (LightmapColor + NdotL * GetShadow(Depth) + Ambient);

	// Declare that we want to use draw buffer 0 with a comment, because of course Minecarft has comments that actually do something lol.
	/* DRAWBUFFERS:0 */
	// Finally write the diffuse color.
	gl_FragData[0] = vec4(Diffuse, 1.0);
}