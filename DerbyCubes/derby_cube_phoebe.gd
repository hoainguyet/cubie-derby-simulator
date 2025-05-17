@tool
extends DerbyCube



# There is a 50% chance to advance an extra pad.
func update_active_roll(params: Dictionary) -> bool:
	if (params["rng"].randf() * 100.0 < 50.0):
		dice += 1
		return true
	return false


