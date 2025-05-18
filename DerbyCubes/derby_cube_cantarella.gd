@tool
extends DerbyCube



var triggering_ability: bool = false



# The first time Cantarella passes by other Cubes,
# she stacks with them and carries them forward.
func update_active_roll(params: Dictionary) -> bool:

	if triggering_ability:
		return false

	var active_cell_i: int = -1
	for iter_cell_i: int in range(cell_i + 1, cell_i + dice):
		if params["cell_map"][iter_cell_i].size() > 0:
			active_cell_i = iter_cell_i
			break

	# If found a cell with players
	# Move them along with her
	if active_cell_i != -1:

		var tween: Tween = params["tween"]
		var new_cell_i: int = wrapi(cell_i + dice, 0, params["cell_map"].size())
		var active_cell: Array = params["cell_map"][active_cell_i]
		var target_cell: Array = params["cell_map"][new_cell_i]

		# Get the rank between the active and target cell
		var over_cube_count: int = 0

		for iter_cell_i: int in range(active_cell_i + 1, new_cell_i + 1):
			if params["cell_map"][iter_cell_i].size() > 0:
				over_cube_count += params["cell_map"][iter_cell_i].size()

				for j: int in range(params["cell_map"][iter_cell_i].size()):
					var cube: DerbyCube = params["cell_map"][iter_cell_i][j]
					cube.rank += active_cell.size()		# + 1 will be updated via cell_list.gd

		for i: int in range(active_cell.size()):
			var cube: DerbyCube = active_cell[i]
			cube.stack_i += target_cell.size()
			cube.cell_i = new_cell_i
			cube.rank -= over_cube_count		 		# - 1 will be updated via cell_list.gd
			cube.z_index = params["cell_list"][cube.cell_i].z_index
			var new_pos: Vector2 = Vector2(
				params["cell_list"][cube.cell_i].position.x,
				-96.0 * cube.stack_i + params["cell_list"][cube.cell_i].position.y - 48.0
			)

			if tween != null:
				tween.parallel().tween_property(
					cube,
					"position",
					new_pos,
					0.5 / SimulatorScreen.move_speed
				).set_trans(Tween.TRANS_SINE)
			else:
				cube.position = new_pos

		target_cell.append_array(active_cell)
		active_cell.clear()

		triggering_ability = true
		return true

	return false


