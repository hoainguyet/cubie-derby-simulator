@tool
extends DerbyCube



# If Calcharo is the last to move, he advances 3 extra pads.
# In fact, the actual activation is when he ranked last (???)
func update_active_roll(params: Dictionary) -> bool:
	if rank == params["player_dict"].size():
		dice += 3
		return true
	return false



