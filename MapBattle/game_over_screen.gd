extends ColorRect



const scale_list: Array[float] = [2.0, 1.5, 1.5]
const position_list: Array[Vector2] = [Vector2.ZERO, Vector2(-256, 32), Vector2(256, 32)]

signal again_tried



func sort_cube_menu_func(a: DerbyCube, b: DerbyCube) -> bool:
	return a.rank < b.rank
	
func add_rank(cube_menu_list: Array) -> void:
	cube_menu_list.sort_custom(sort_cube_menu_func)
	for i: int in range(min(3, cube_menu_list.size())):
		var sample: PackedScene = load(
			"res://DerbyCubes/derby_cube_" + 
		 	cube_menu_list[i].cube_name +
			".tscn"
		)
		var cube: DerbyCube = sample.instantiate()
		$FirstPlace.add_child(cube)
		cube.position = position_list[i]
		cube.scale = Vector2(scale_list[i], scale_list[i])
		cube.rank = cube_menu_list[i].rank
	$Label.text = cube_menu_list[0].cube_name.capitalize() + " has won the race!"

func _on_button_pressed() -> void:
	again_tried.emit()


