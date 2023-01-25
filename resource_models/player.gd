extends Resource
class_name Player


enum CLASS {FIGHTER, WIZARD, PIRATE}
@export var player_name : String
@export var class_type : CLASS
@export var stats : Stats


func _init(
	player_name_p := "",
	class_type_p := CLASS.FIGHTER,
	stats_p := Stats.new()) -> void:

	player_name = player_name_p
	class_type_p = class_type_p
	stats = stats_p
