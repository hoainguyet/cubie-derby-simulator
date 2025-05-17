@tool
extends DerbyCube



# There is a 50% chance of triggering this effect on Camellya's turn.
# For every other Cube on the same pad besides Camellya, she advances 1 extra pad,
# while the other Cubes stay in place.
func update_active_roll(params: Dictionary) -> bool:

	var cell: Array = params["cell_map"][cell_i]
	var tween: Tween = params["tween"]
	if (cell.size() > 1) and (params["rng"].randf() * 100.0 < 50.0):
		# Change all ranks
		# Move all cubes above
		for new_stack_i: int in range(stack_i + 1, cell.size()):
			var cube: DerbyCube = cell[new_stack_i]
			cube.stack_i -= 1
			cube.rank += 1
			if tween != null:
				tween.parallel().tween_property(
					cube,
					"position:y",
					-96.0 * cube.stack_i + params["cell_list"][cell_i].position.y - 48.0,
					0.5 / SimulatorScreen.move_speed
				).set_trans(Tween.TRANS_SINE)
			else:
				cube.position.y = -96.0 * cube.stack_i + params["cell_list"][cell_i].position.y - 48.0

		var cell_size: int = cell.size()
		cell.remove_at(stack_i)
		cell.append(self)
		rank -= cell_size - 1 - stack_i
		stack_i = cell_size - 1
		dice += cell_size - 1

		return true

	return false


