extends Resource
class_name SaveFile

#this custom class is the main save file that can store any custom data types added to it
#it can be a composition of player data and game state data
@export var player : Player
@export var timestamp : String
@export var version : String


func _init(
	player_p := Player.new(),
	timestamp_p : String = str(Time.get_unix_time_from_system()),
	version_p : String = ProjectSettings.get_setting("global/version")) -> void:

	player = player_p
	timestamp = timestamp_p
	version = version_p
