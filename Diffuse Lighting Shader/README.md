# Diffuse Lighting

* Add diffuse lighting (brighten or darken textures) based on the sun's position.
* Add shadows cast based on the sun's position.
* Refine and blur the shadows so they look better (no hard edges and no longer blocky).

This is accomplished using the following shader passes:

* `gbuffers_terrain`, `gbuffers_entities`, and `gbuffers_hand`, which handles the default block, entity, and player-hand rendering and ambient occlusion, before lighting and stuff is applied.
* `shadow`, which simply passes the shadow texture.
* `composite`, which does the majority of the lighting and diffuse calculations, and pulls from the previous shader passes to draw shadows as well.
* `final`, which gamma corrects the color before finally outputting to the screen.
* `distort`, which simply holds a function for distorting shadow vertices, which is used in two separate shaders.