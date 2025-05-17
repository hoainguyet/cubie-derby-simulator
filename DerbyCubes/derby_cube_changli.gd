@tool
extends DerbyCube



var last_move: bool = false



# If other Cubes are stacked below Changli,
# there is a 65% chance she will be the last to move in the next turn.
func update_passive_roll(params: Dictionary) -> bool:
	# The first condition is to avoid her moving and then activated
	if (stack_i > 0) and \
			(stack_i == params["cell_map"][cell_i].size() - 1) and \
			(params["rng"].randf() * 100.0 < 65.0):
		last_move = true
		return true
	return false



func update_before_roll(params: Dictionary) -> void:
	if last_move:
		last_move = false
		var cube_menu_list: Array = params["new_cube_menu_list"]
		var pinned_i: int = -1
		# Look for current turn, then swap it with the last turn
		for i: int in range(cube_menu_list.size()):
			if cube_menu_list[i].cube_name == cube_name:
				pinned_i = i
		# Swap
		var temp: DerbyCube = cube_menu_list[-1]
		cube_menu_list[-1] = cube_menu_list[pinned_i]
		cube_menu_list[pinned_i] = temp

