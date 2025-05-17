@tool
extends DerbyCube



# There is a 28% chance to advance twice with the rolled number.
func update_active_roll(params: Dictionary) -> bool:
	if (params["rng"].randf() * 100.0 < 28.0):
		dice *= 2
		return true
	return false


