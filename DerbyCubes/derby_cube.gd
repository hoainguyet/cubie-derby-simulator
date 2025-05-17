@tool
class_name DerbyCube extends Node2D



@export var rank: int = 1 :
	set (value):
		rank = value
		if get_node_or_null("WhiteSection/Label") != null:
			$WhiteSection/Label.text = get_rank(value)

@export var cube_name: String = ""

var stack_i: int = 0		# Followed by FILO
var cell_i: int = 0

func run_temp() -> void:
	$WhiteSection/Label2.text = str(stack_i)
	$WhiteSection/Label3.text = str(cell_i)



var dice: int = 0
func get_roll_dice(dice_rng: RandomNumberGenerator) -> int:
	dice = dice_rng.randi_range(1, 3)
	return dice



# Active update will be activated right before moving
func update_active_roll(_params: Dictionary) -> bool:
	# curr_dice: roll will usually range from 1 to 3
	# stack_height: the current position of the cube in the certain cell
	#               every cube can stack or be stacked
	# stack_arr: the array of the stack
	# order: the order of the cube in a turn. Range from 0 to 5, where 0 will start first.
	return false



# Passive update will be activated in some circumstances
func update_passive_roll(_params: Dictionary) -> bool:
	return false



func update_before_roll(_params: Dictionary) -> void:
	pass



static func get_rank(value: int) -> String:
	match value % 10:
		1:
			if value % 100 == 11:
				return "11th"
			else:
				return str(value) + "st"
		2:
			if value % 100 == 12:
				return "12th"
			else:
				return str(value) + "nd"
		3:
			if value % 100 == 13:
				return "13th"
			else:
				return str(value) + "rd"
		_:
			return str(value) + "th"


