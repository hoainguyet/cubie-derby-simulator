extends ColorRect



var CODEX_players: Dictionary = {}
var button_list: Array = []

@export var SelectionButtonSample: PackedScene

signal selected(name_list: Dictionary)



func update_toggled(player_list: Array) -> void:
	for button: Control in button_list:
		if button.cube_name in player_list:
			button.set_toggled(true)



func _ready() -> void:
	var f: FileAccess = FileAccess.open("res://Logs/players.json", FileAccess.READ)
	CODEX_players = JSON.parse_string(f.get_as_text())
	f.close()

	for player_name: String in CODEX_players:
		var button: Control = SelectionButtonSample.instantiate()
		$ScrollContainer/VBoxContainer.add_child(button)
		button.set_cube(
			player_name,
			CODEX_players[player_name]["name"],
			CODEX_players[player_name]["ability_description"]
		)
		button_list.append(button)



func _on_button_pressed() -> void:
	var name_list: Array = []
	for button: Control in button_list:
		if button.selected:
			name_list.append(button.cube_name)
	if name_list.size() > 0:
		selected.emit(name_list)


