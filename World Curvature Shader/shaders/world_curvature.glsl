const float WORLD_CURVATURE_SIZE = 256;

float worldCurvature(vec4 position)
{
	return dot(position.xz, position.xz) / WORLD_CURVATURE_SIZE; // World curvature formula.
}