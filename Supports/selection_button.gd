extends ColorRect



var cube_name: String = ""
var selected: bool = false




func set_cube(value: String, cube_real_name: String, cube_description: String) -> void:
	cube_name = value
	if get_node_or_null("CenterPos") != null:
		var sample: PackedScene = load("res://DerbyCubes/derby_cube_" + cube_name + ".tscn")
		var cube: DerbyCube = sample.instantiate()
		$CenterPos.add_child(cube)
		$Name.text = cube_real_name
		$Description.text = cube_description



func set_toggled(toggled_on: bool) -> void:
	$Button.button_pressed = toggled_on
	_on_button_toggled(toggled_on)



func _on_button_toggled(toggled_on: bool) -> void:
	selected = toggled_on
	if toggled_on:
		$Selecting.show()
	else:
		$Selecting.hide()


