extends Node2D



@export var ordered_cell_node_list: Array[MapCell] = []		# List of cell nodes
var cell_map: Array = []
var player_dict: Dictionary = {}
var ability_rng: RandomNumberGenerator = RandomNumberGenerator.new()

signal rank_changed(cube_name: String, rank: int)
signal ability_activated(cube_name: String)



func add_initial_players(rank_player_list: Array) -> void:

	for i: int in range(rank_player_list.size() - 1, -1, -1):
		var sample: PackedScene = load(
			"res://DerbyCubes/derby_cube_" + 
		 	rank_player_list[i].cube_name +
			".tscn"
		)
		var cube: DerbyCube = sample.instantiate()
		add_child(cube)

		player_dict[cube.cube_name] = cube
		cube.rank = i + 1
		cube.stack_i = rank_player_list.size() - i - 1
		cube.cell_i = 0
		cube.z_index = ordered_cell_node_list[0].z_index
		rank_player_list[i].rank = i + 1
		move_cube(cube.cube_name, 0)



func remove_initial_players() -> void:
	for i: int in range(cell_map.size()):
		for j: int in range(cell_map[i].size()):
			var cube: DerbyCube = cell_map[i][j]
			remove_child(cube)
			cube.queue_free()
		cell_map[i].clear()
	player_dict.clear()



func move_cube(cube_name: String, cell_i: int, tween: Tween = null) -> void:
	var cube: DerbyCube = player_dict[cube_name]
	var new_pos: Vector2 = ordered_cell_node_list[cell_i].position
	new_pos += Vector2(0.0, -96.0) * cell_map[cell_i].size() - Vector2(0.0, 48.0)
	if tween != null:
		tween.parallel().tween_property(cube, "position", new_pos, 0.5 / SimulatorScreen.move_speed).set_trans(Tween.TRANS_SINE)
	else:
		cube.position = new_pos
	cell_map[cell_i].append(cube)
	cube.run_temp()



func move_cube_and_above(order: int, cube_name: String, animating: bool = true) -> bool:

	var cube: DerbyCube = player_dict[cube_name]
	var tween: Tween = create_tween() if animating else null

	# Before moving, activate the power
	var params: Dictionary = {
		"name": cube.cube_name,
		"cell_list": ordered_cell_node_list,
		"cell_map": cell_map,
		"order": order,
		"player_dict": player_dict,
		"tween": tween,
		"rng": ability_rng
	}
	if cube.update_active_roll(params):
		ability_activated.emit(cube.cube_name)
		print("activate " + cube.cube_name + " ability (active)")

	var stack_i: int = cube.stack_i
	var cell_i: int = wrapi(cube.cell_i, 0, cell_map.size())
	var new_cell_i: int = cube.cell_i + cube.dice
	var reaching_end: bool = false
	if new_cell_i >= ordered_cell_node_list.size() - 1:
		new_cell_i = ordered_cell_node_list.size() - 1
		reaching_end = true

	var old_cell_size: int = cell_map[cell_i].size()
	var new_cell_size: int = cell_map[new_cell_i].size()
		
	# Update rank
	# Check if there are cubes between the old and the new cells
	var over_cube_list: Array = []
	for iter_cell_i: int in range(cell_i + 1, new_cell_i + 1):
		if cell_map[iter_cell_i].size() > 0:
			over_cube_list.append_array(cell_map[iter_cell_i])

	# Cube being jumped over will be lowered the rank
	for over_cube: DerbyCube in over_cube_list:
		over_cube.rank += old_cell_size - stack_i
		rank_changed.emit(over_cube.cube_name, over_cube.rank)

	# And all new cubes will have their rank increased
	for i: int in range(stack_i, old_cell_size):
		var iter_cube: DerbyCube = cell_map[cell_i][i]
		iter_cube.rank -= over_cube_list.size()
		rank_changed.emit(iter_cube.cube_name, iter_cube.rank)

	# Move objects
	var updated: bool = false
	for i: int in range(stack_i, old_cell_size):
		var iter_cube: DerbyCube = cell_map[cell_i][i]

		iter_cube.cell_i = new_cell_i
		iter_cube.stack_i = i - stack_i + new_cell_size
		cube.z_index = ordered_cell_node_list[new_cell_i].z_index
		move_cube(iter_cube.cube_name, new_cell_i, tween)
		updated = true
	
	if not updated:
		tween.kill()

	# Activate passive abilities for the target cell (Jinhsi, Changli)
	activate_passive(cube_name, new_cell_i, animating)

	# Remove elements
	for i: int in range(old_cell_size - 1, stack_i - 1, -1):
		cell_map[cell_i].remove_at(i)

	return reaching_end



func activate_passive(cube_name: String, cell_i: int, animating: bool) -> void:

	await get_tree().create_timer(0.5 / SimulatorScreen.move_speed).timeout

	var tween: Tween = create_tween() if animating else null
	var params: Dictionary = {
		"name": cube_name,
		"cell_list": ordered_cell_node_list,
		"cell_map": cell_map, "player_dict": player_dict,
		"tween": tween, "activating_tween": false, "rng": ability_rng
	}
	for cube: DerbyCube in cell_map[cell_i]:
		if cube.update_passive_roll(params):
			ability_activated.emit(cube.cube_name)
			print("activate " + cube.cube_name + " ability (passive)")
	
	if not params["activating_tween"]:
		tween.kill()



func _ready() -> void:
	ability_rng.randomize()
	cell_map.resize(ordered_cell_node_list.size())
	for cell_i: int in range(cell_map.size()):
		cell_map[cell_i] = []
	var z_sort_ordered_cell_node_list: Array = ordered_cell_node_list.duplicate()
	z_sort_ordered_cell_node_list.sort_custom(func (a: MapCell, b: MapCell) -> bool: return a.position.y < b.position.y)
	for i: int in range(z_sort_ordered_cell_node_list.size()):
		z_sort_ordered_cell_node_list[i].z_index = i


