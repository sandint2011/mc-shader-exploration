#version 120

varying vec2 TexCoords;

// Direction of the sun (not normalized).
uniform vec3 sunPosition;

// The color texutre which we wrote to in `gbuffers_terrain`.
uniform sampler2D colortex0; // Albedo.
uniform sampler2D colortex1; // Normal.
uniform sampler2D colortex2; // Lighting
uniform sampler2D shadowtex0; // Shadow

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;


// Set the out color texture formats,
// using a comment because of course Minecraft would code with comments.
/*
const int colortex0Format = RGBA16F;
const int colortex1Format = RGB16;
const int colortex2Format = RGB16;
*/

// Optifine will read this variable.
const float sunPathRotation = -40.0; // How titled the sun path is, in degrees.
const int shadowMapResolution = 1024
const float Ambient = 0.025f;

float GetShadow(float depth){
	vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
	vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
	vec3 View = ViewW.xyz / ViewW.w;
	vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
	vec4 ShadowSpace = shadowProjection * shadowModelView * World;
	vec3 SampleCoords = ShadowSpace.xyz * 0.5f + 0.5f;

	return step(SampleCoords.z - 0.001f, texture2D(shadowtex0, SampleCoords.xy).r);
}


float AdjustLightmapTorch(in float torch) {
    const float K = 2.0f;
    const float P = 5.06f;
    return K * pow(torch, P);
}

float AdjustLightmapSky(in float sky){
    float sky_2 = sky * sky;
    return sky_2 * sky_2;
}

vec2 AdjustLightmap(in vec2 Lightmap){
    vec2 NewLightMap;
    NewLightMap.x = AdjustLightmapTorch(Lightmap.x);
    NewLightMap.y = AdjustLightmapSky(Lightmap.y);
    return NewLightMap;
}

// Input is not adjusted lightmap coordinates
vec3 GetLightmapColor(in vec2 Lightmap){
    // First adjust the lightmap
    Lightmap = AdjustLightmap(Lightmap);
    // Color of the torch and sky. The sky color changes depending on time of day but I will ignore that for simplicity
    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
    const vec3 SkyColor = vec3(0.05f, 0.15f, 0.3f);
    // Multiply each part of the light map with it's color
    vec3 TorchLighting = Lightmap.x * TorchColor;
    vec3 SkyLighting = Lightmap.y * SkyColor;
    // Add the lighting togther to get the total contribution of the lightmap the final color.
    vec3 LightmapLighting = TorchLighting + SkyLighting;
    // Return the value
    return LightmapLighting;
}


void main() {
	// Account for gamma correction because textures have gamma already.
	vec3 Albedo = pow(texture2D(colortex0, TexCoords).rgb, vec3(2.2f));
	float Depth = texture2D(depthtex0, TexCoords).r;
	if(Depth == 1.0f){
    gl_FragData[0] = vec4(Albedo, 1.0f);
    return;
}

	// Get the normal and bring it to [-1, 1] range.
	vec3 Normal = normalize(texture2D(colortex1, TexCoords).rgb * 2.0 - 1.0);

	// Get the lightmap
	vec2 Lightmap = texture2D(colortex2,TexCoords).rg;

	// Get lightmap color
	vec3 LightmapColor = GetLightmapColor(Lightmap);

	// Computer the cosine theta between the normal and sun directions.
	float NdotL = max(dot(Normal, normalize(sunPosition)), 0.0);

	// Do the lighting calculations.
	vec3 Diffuse = Albedo * (LightmapColor + NdotL * GetShadow(Depth) + Ambient);	// Declare access to draw buffers 0,
	// using a comment because of course Minecraft would code with comments.
	// Then write the diffuse color.
	/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(Diffuse, 1.0); // This will re-gamma correct in the built-in final shader pass.
}