# MCBESwitcher+ | Foxy's Bedrock Profile & Version Switcher
Minecraft Bedrock Edition Version Switcher
Made for MC Bedrock Edition 1.19+

# YOU WILL NEED TO HAVE ADMINISTRATOR PRIVALEGES ON YOUR DEVICE FOR THIS TO WORK!!!

# NOTE: VERSION NAMING #
Add all of your Version folders into the Versions directory.
The app will read the files inside of your version folders to determine if they are Minecraft or Minecraft Preview Versions
However it's a good idea to get into the habbit of naming your versions properly...

-> Minecraft Stable Releases: 	Minecraft-VERSION   		[e.g. Minecraft-1.18.0.34]
-> Minecraft Beta Releases: 	Minecraft-Beta-VERSION 		[e.g. Minecraft-Beta-1.19.0.32]
-> Minecraft Preview: 			Minecraft-Preview-VERSION 	[e.g. Minecraft-Preview-1.19.10.20]

# WHAT IS IT?
MCBESwitcher is an app that allows you to have multiple Minecraft (Bedrock Edition) profiles and versions on the same Windows device.
You can switch Minecraft versions and Minecraft Preview versions but keep the same profile between them so you can share your worlds, packs and settings across all versions and preview versions.


# WHAT IS A PROFILE
A profile is all of the settings, resource packs, behaviour packs, worlds, skin packs, world templates that Minecraft uses when it's loaded.
It normally lives inside the com.mojang folder on your computer.

By creating multiple Profiles it is possible, using this app, to make Minecraft Preview use a different profile when it launches.
For instance, you could have your standard profile, with all of your normal worlds and settings, and you could have a second profile that has lower graphics settings, different resource packs enabled and a different list of worlds for your alt account.

There are lots of reasons for having multiple profiles. One of the best reasons is that when you uninstall Minecraft Preview, for whatever reason, your profile data won't get deleted like it normally does during the uninstall process. So it's there when you reinstall, just like you left it!

The other good reason for using a profile instead of the default profile is that you can store it anywhere on any drive, so your worlds and resource packs won't eat up all the space on your boot drive!


# HOW TO MAKE PROFILES
Easy, just make an directory inside of the "Profiles" directory.
When you start the app, choose the new directory name and when you hit launch, Minecraft will load with all of the default settings and the folder structure inside of your new profile will be created.

Alternatively, you can just copy everything inside of the com.mojang folder found here: %localappdata%\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang

Selecting the "Default" profile will tell Minecraft to use the normal com.mojang directory.
Selecting any of your custom ones will tell Minecraft to use your new Profile directories.
So when you install a resource pack or make a new world, they'll be stored inside your new Profile directory.


# WHAT IS A VERSION
Versions are the different releases of Minecraft or the Minecraft Preview for example 1.19.0.35 and 1.19.10.20
Each of these main versions has many different sub versions that get released as the game is developed, fixed and updated.
As of writing this Minecraft 1.18.0.34 is the latest stable version and Minecraft Preview 1.19.10.20 is the latest preview version.

Normally, to switch between these versions, you may lose all of your worlds, settings and packs.

Using this software, you can pick whatever version you want to play and just launch it, without having to opt into the Preview or installing anything.

The versions will be automatically downloaded when you choose which version you wish to play from the list.
You can add your own versions by following the naming system above.


# HOW TO INSTALL
	1. Make sure you have Administrative Privileges on the Device and User Account you're using.
	2. Make a complete backup of your Minecraft Folders: %localappdata%\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang]
	3. Make a complete backup of your Minecraft Preview Folders: %localappdata%\Packages\Microsoft.MinecraftWindowsBeta_8wekyb3d8bbwe\LocalState\games\com.mojang]
	4. Download the latest version from https://foxynotail.com
	5. Unizip the MCBSwitcherPlus-VERSION.zip file into any new folder on your PC where you want your Profiles and Versions to live.
	6. Follow "How do you make profiles?" above to create new profiles.
	8. Run MCBESwitcher.exe as an administrator
	9. Choose your desired profile and version and hit launch.
	
# FAQ
Q: I don't have any profiles other than Default
A: Make sure your options.txt file has the profile_dir pointing at where you're keeping your profiles.

Q: When I choose another profile Minecraft launches slowly and none of my packs or worlds are there.
A: Make sure you're running with Administrative Privileges. This system changes permissions of folders on your PC to allow Minecraft to see inside of them. If it can't change those permissions, Minecraft won't be able to see inside your profile folders and will load with nothing.

Q: It didn't work
A: What didn't work?

Q: Switching versions isn't working
A: 	1. Make sure you're running with Administrative Privileges. 
	2. This system adds and updates appx packages behind the scenes using PowerShell. 
	3. Make sure you have PowerShell installed.
	4. Make sure the store version of Minecraft and the Minecraft Preview are uninstalled
	5. This should only be attempted by advanced users that understand computers, permissions, directory structures etc.
