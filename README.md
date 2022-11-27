# MC Shader Exploration

## Installations & Setup

### Downloads

Download the following installers and files.

1. Alternatively, download and install [MultiMC](https://multimc.org/#Download).
1. Download and install [Java 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html).
1. Download [Optine](https://optifine.net/downloads) for version `1.19.2`.

### Install Steps

Follow these steps to install and setup Minecraft, MultiMC, and Optifine, to support shader mods.

1. In the MultiMC Settings, under the Java tab:
    1. Set the minimum memory allocation to `512 MiB` and the maximum to `4096 MiB`, to give Minecraft more RAM.
    1. Under the Java Runtime section, click Auto-Detect and select the Java 17 version.
1. Create a Minecraft instance in MultiMC for version `1.19.2` and launch it, then close it.
1. In MultiMC, click on the 1.19.2 instance and go to Edit Instance:
    1. In the Version tab, click Install Forge and hit OK.
    1. In the Loader mods tab, click Add and select the Optifine `.jar` file downloaded earlier.

## Usage

### Using Shaders

Launch the modified Minecraft 1.1.92 instance through MultiMC, after following the installation steps above.

Create or open up a world and hit ESCAPE and go to Options > Video Settings > Shaders. Select the shader you'd like to play around with. I recommend switching the world from Survival Mode ro Creative Mode, so you can explore the shaders without worying about dying.

### Adding More Shaders

Shaders are added as folders or `.zip` files by going to MultiMC > 1.19.2 > Edit Instance > Shader Packs > Add and selecting one of the shaders from this repository.

## Links

* Based on this [tutorial](https://github.com/saada2006/MinecraftShaderProgramming).
* Using [Minecraft Java Edition](https://www.minecraft.net/download) (no need to install this, though).
* Using the third party Minecraft launcher, [MultiMC](https://multimc.org/#Download).
    * This is used because Windows broke Minecraft such that it can't run if your Windows Microsoft account doesn't match your Minecraft Microsoft account.
* Using the [Optifine](https://optifine.net/downloads) mod for Minecraft (which adds shader support and extra graphical settings/options).
