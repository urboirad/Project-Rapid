## [color=yellow]PLEASE IGNORE![/color] This is a important Node wich gets automatically added as Singleton.
## 
## The DiscordSDKLoader Node automatically gets added as Singleton while installing the addon.
## It has to run in the background to comunicate with Discord.
## You don't need to use it.
##
## @tutorial: https://github.com/vaporvee/discord-sdk-godot/wiki
class_name core_updater
extends Node

func _ready():
	discord_sdk.app_id = 1109157117794988092 # Application ID
	print("Discord working: " + str(discord_sdk.get_is_discord_working())) # A boolean if everything worked
	discord_sdk.details = "SAGE '23 Demo"
	discord_sdk.state = "Playing"
	
	discord_sdk.large_image = "pricon" # Image key from "Art Assets"
	discord_sdk.large_image_text = "TIME IS RUNNING OUT!"
	discord_sdk.small_image = "logosmallhd" # Image key from "Art Assets"
	discord_sdk.small_image_text = ""

	discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
	# discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"

	discord_sdk.refresh() # Always refresh after changing the values!

func _process(delta) -> void:
	discord_sdk.coreupdate()
