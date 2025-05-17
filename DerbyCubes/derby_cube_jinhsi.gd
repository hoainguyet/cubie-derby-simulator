@tool
extends DerbyCube



# If other Cubes are stacked on top of Jinhsi,
# there is a 40% chance she will move to the top of the stack.
func update_passive_roll(params: Dictionary) -> bool:

	var cell: Array = params["cell_map"][cell_i]
	var tween: Tween = params["tween"]
	if (cell.size() > 1) and (stack_i < cell.size() - 1) and (params["rng"].randf() * 100.0 < 40.0):
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
				params["activating_tween"] = true
			else:
				cube.position.y = -96.0 * cube.stack_i + params["cell_list"][cell_i].position.y - 48.0

		var cell_size: int = cell.size()
		cell.remove_at(stack_i)
		cell.append(self)
		rank -= cell_size - 1 - stack_i
		stack_i = cell_size - 1
		if tween != null:
			tween.parallel().tween_property(
				self,
				"position:y",
				-96.0 * stack_i + params["cell_list"][cell_i].position.y - 48.0,
				0.5 / SimulatorScreen.move_speed
			).set_trans(Tween.TRANS_SINE)
			params["activating_tween"] = true
		else:
			position.y = -96.0 * stack_i + params["cell_list"][cell_i].position.y - 48.0

		return true

	return false




