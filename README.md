# MC Shader Exploration

This repository holds some shaderpacks we made for for Minecraft. We followed this [tutorial](https://github.com/saada2006/MinecraftShaderProgramming) to learn how to write shaders, and then used what we learned to write more complicated shaders.

## Links

* Based on this [tutorial](https://github.com/saada2006/MinecraftShaderProgramming).
* Using [Minecraft Java Edition](https://www.minecraft.net/download) (no need to install this, though).
* Using the third party Minecraft launcher, [MultiMC](https://multimc.org/#Download).
    * This is used because Windows broke Minecraft such that it can't run if your Windows Microsoft account doesn't match your Minecraft Microsoft account.
* Using the [Optifine](https://optifine.net/downloads) mod for Minecraft (which adds shader support and extra graphical settings/options).

### Development

* [Optifine Shaders Documentation](https://optifine.readthedocs.io/shaders_dev.html).

## Installations & Setup

### Downloads

Download the following installers and files.

1. Alternatively, download and install [MultiMC](https://multimc.org/#Download).
1. Download and install [Java 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html).
1. Download [Optine](https://optifine.net/downloads) for version `1.19.2`.

### Install Steps

Follow these steps to install and setup Minecraft, MultiMC, and Optifine, to support shaders.

1. In the MultiMC _Settings_, under the _Java_ tab:
    1. Set the _Minimum memory allocation_ to `512 MiB` and the _Maximum memory allocation_ to `4096 MiB`, to give Minecraft more RAM since shaders require more processing power than default Minecraft.
    1. Under the _Java Runtime_ section, click _Auto-Detect_ and select the Java 17 version.
1. In MultiMC, click _Add Instance_ to create a Minecraft instance for version `1.19.2`.
1. In MultiMC, click on the _1.19.2_ instance and go to _Edit Instance_:
    1. In the _Version_ tab, click _Install Forge_ and hit _OK_.
    1. In the _Loader Mods_ tab, click _Add_ and select the Optifine `.jar` file downloaded earlier.

## Usage

### Using Shaders

Launch the modified Minecraft 1.1.92 instance through MultiMC, after following the installation steps above.

Create or open up a world and hit ESCAPE and go to _Options_ > _Video Settings..._ > _Shaders..._. Select the shader you'd like to play around with. I recommend switching the world from _Survival Mode_ to _Creative Mode_, so you can explore the shaders without worying about dying.

There will be READMEs inside each shader folder, explaining in further detail what the shader does.

### Adding Shaders to Minecraft

Shaders are added as folders or `.zip` files by clicking on the _1.19.2_ instance in MultiMC and goint to _Edit Instance_ > _Shader Packs_ > _Add_ and selecting one of the shaders from this repository.

Feel free to download [BSL Shaders](https://www.bslshaders.com/download/) if you'd like an example of a fully developed shader that's used by the community.

When making changes to a shader, you'll need to switch the selected shader in Minecraft to `OFF` and back, to tell Minecraft to reload the shader.
