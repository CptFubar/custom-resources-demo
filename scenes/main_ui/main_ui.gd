extends CanvasLayer


# defining the save path for save files within the user space
var save_path : String = "user://saves"
var save_file_name : String = "save.tres"
#loading in example data with stats and player
var stats := Stats.new()
var player := Player.new()

@onready var character_name: LineEdit = $"%Name"
@onready var class_button: OptionButton = $"%ClassButton"
@onready var strength_input_field: SpinBox = $"%Strentgh"
@onready var magic_input_field: SpinBox = $"%Magic"
@onready var dexterity_input_field: SpinBox = $"%Dexterity"
@onready var action_log: RichTextLabel = $"%ActionLog"
@onready var time_stamp: Label = $"%TimeStamp"
@onready var version: Label = $"%Version"


func _ready() -> void:
	#populate the Charcter Class button with options
	for class_type in Player.CLASS:
		class_button.add_item(class_type.capitalize(), Player.CLASS.get(class_type))
	action_log.clear()
	#clearing the meta data fields on start
	time_stamp.text = ""
	version.text = ""
	character_name.grab_focus()


func generate_save_dir(path:String) -> void:
	var dir = DirAccess.open(path)

	if dir == null :
		var error = DirAccess.make_dir_absolute(path)
		if error != OK:
			action_log.append_text("%s can't generate the save file folder\n" % get_line())
			return
		action_log.append_text("%s Direcotry: %s created\n" % [get_line(),path])


func get_line() -> String:
	return str(action_log.get_line_count(),":")


func _on_save_pressed() -> void:
	if character_name.text == "":
		action_log.add_text("%s Character Name field needs to have a value, saving failed!\n" % get_line())
		return

	generate_save_dir(save_path)

	player.player_name = character_name.text
	player.class_type = class_button.selected
	stats.strength = strength_input_field.value
	stats.magic = magic_input_field.value
	stats.dexterity = dexterity_input_field.value
	player.stats = stats

	var new_save = SaveFile.new(player)
	var err = ResourceSaver.save(new_save,save_path.path_join(save_file_name))
	if err != OK:
		action_log.add_text("%s Couldn't save, error: %s\n" % [get_line(),err])
		return
	action_log.add_text("%s File saved successfully to %s !\n" % [get_line(),save_path.path_join(save_file_name)])


func _on_load_button_pressed() -> void:
	var loaded_values
	if ResourceLoader.exists(save_path.path_join(save_file_name)):
		loaded_values = ResourceLoader.load(save_path.path_join(save_file_name),"SaveFile",ResourceLoader.CACHE_MODE_REPLACE)
		action_log.add_text("%s Resource file loaded %s\n" % [get_line(),save_path.path_join(save_file_name)])
	else:
		action_log.add_text("%s Resource does not exist, unable to load save file at path %s !\n" % [get_line(),save_path.path_join(save_file_name)])

	if loaded_values != null:
		player = loaded_values.player
		stats = player.stats

		character_name.text = player.player_name
		class_button.select(player.class_type)
		strength_input_field.value = stats.strength
		magic_input_field.value = stats.magic
		dexterity_input_field.value = stats.dexterity
		#Meta Data
		time_stamp.text = Time.get_datetime_string_from_unix_time(int(loaded_values.timestamp),true)
		version.text = loaded_values.version


func _on_reset_pressed() -> void:
	character_name.text = ""
	class_button.select(Player.CLASS.FIGHTER)
	strength_input_field.value = 0
	magic_input_field.value = 0
	dexterity_input_field.value = 0
	time_stamp.text = ""
	version.text = ""
	action_log.add_text("%s Cleared all fields.\n" % get_line())


func _on_open_dir_pressed() -> void:
	var err = OS.shell_open(ProjectSettings.globalize_path(save_path))
	if err != OK:
		action_log.append_text("%s Couldn't open save file folder, probably does not exist yet, try and save at least once.\n" % get_line())


func _on_name_text_submitted(_new_text: String) -> void:
	var input_event = InputEventAction.new()
	input_event.action = "ui_focus_next"
	input_event.pressed = true
	Input.parse_input_event(input_event)
