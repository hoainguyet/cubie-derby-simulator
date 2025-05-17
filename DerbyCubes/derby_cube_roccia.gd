@tool
extends DerbyCube



# If Roccia is the last to move, she advances 2 extra pads.
func update_active_roll(params: Dictionary) -> bool:
	if params["order"] == params["player_dict"].size() - 1:
		dice += 2
		return true
	return false


