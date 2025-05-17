@tool
extends DerbyCube



# If Brant is the first to move, he advances 2 extra pads.
func update_active_roll(params: Dictionary) -> bool:
	if params["order"] == 0:
		dice += 2
		return true
	return false


