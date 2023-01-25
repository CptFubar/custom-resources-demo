extends Resource
class_name Stats


@export var strength : int
@export var magic : int
@export var dexterity : int


func _init(
	strength_p : int = 0,
	magic_p : int = 0,
	dexterity_p : int = 0) -> void:

	strength = strength_p
	magic = magic_p
	dexterity = dexterity_p

