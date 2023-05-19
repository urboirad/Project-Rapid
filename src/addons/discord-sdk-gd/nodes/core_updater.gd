## This always needs to run in the background if you want to comunicate with the discord client.
extends Node

@export var is_running: bool =false

func _ready():
	discord_sdk.app_id = 1109157117794988092 # Application ID
	print("Discord working: " + str(discord_sdk.get_is_discord_working())) # A boolean if everything worked
	discord_sdk.details = "Project Rapid SAGE 2023 Demo"
	discord_sdk.state = "Playing"
	
	discord_sdk.large_image = "pricon" # Image key from "Art Assets"
	discord_sdk.large_image_text = "TIME IS RUNNING OUT!"
	discord_sdk.small_image = "boss" # Image key from "Art Assets"
	discord_sdk.small_image_text = "Fighting the end boss! D:"

	discord_sdk.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
	# discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00 remaining"

	discord_sdk.refresh() # Always refresh after changing the values!

func _process(delta) -> void:
	discord_sdk.coreupdate()
	is_running = true
