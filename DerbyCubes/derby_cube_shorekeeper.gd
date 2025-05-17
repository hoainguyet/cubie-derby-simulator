@tool
extends DerbyCube



# The dice will only roll a 2 or 3.
func get_roll_dice(dice_rng: RandomNumberGenerator) -> int:
	dice = dice_rng.randi_range(2, 3)
	return dice


