@tool
extends DerbyCube



var advanced: bool = false



# The dice will only roll a 1 or 3.
# When moving with other Cubes stacking above,
# there is a 40% chance to advance 2 extra pads next turn.
func get_roll_dice(dice_rng: RandomNumberGenerator) -> int:
	dice = 1 if (dice_rng.randi() % 2 == 0) else 3
	return dice



func update_active_roll(_params: Dictionary) -> bool:
	if advanced:
		advanced = false
		dice += 2
	return false



func update_passive_roll(params: Dictionary) -> bool:
	if (params["name"] == cube_name) and							\
			(params["cell_map"][cell_i].size() > 1) and				\
			(stack_i < params["cell_map"][cell_i].size() - 1) and	\
			(params["rng"].randf() * 100.0 < 40.0):
		advanced = true
		return true
	return false


