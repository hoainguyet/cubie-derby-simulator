@tool
extends DerbyCube



var advanced: bool = false



func update_active_roll(_params: Dictionary) -> bool:
	if advanced:
		dice += 2
	return false



# If ranked last after own action,
# there is a 60% chance to advance 2 extra pads in all remaining turns.
# This can only be triggered once in each match.
func update_passive_roll(params: Dictionary) -> bool:
	if (params["name"] == cube_name) and					\
			(rank == params["player_dict"].size()) and		\
			(params["rng"].randf() * 100.0 < 60.0) and		\
			not advanced:
		advanced = true
		return true
	return false


