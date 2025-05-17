extends SimulatorState



var starting: bool = true
var dice_rng: RandomNumberGenerator = RandomNumberGenerator.new()



func _ready() -> void:
	dice_rng.randomize()



func activate() -> void:
	if stopping:
		return
	randomise_cubes(true)
	if starting:
		starting = false
		Outside_CellList.add_initial_players(Outside_SimulatorScreen.cube_menu_list)

	for cube_name: String in Outside_CellList.player_dict:
		var dice: int = Outside_CellList.player_dict[cube_name].get_roll_dice(dice_rng)
		Outside_SimulatorScreen.update_roll_dice(cube_name, dice)
	
	$OrderTimer.wait_time = 1.0 / SimulatorScreen.move_speed
	$OrderTimer.start()



func reset() -> void:
	starting = true
	Outside_CellList.remove_initial_players()



func randomise_cubes(animating: bool) -> void:

	if stopping:
		return

	var old_list: Array = Outside_SimulatorScreen.cube_menu_list
	var new_list: Array = []
	new_list.resize(old_list.size())

	for i: int in range(old_list.size()):
		var extract_i: int = dice_rng.randi() % old_list.size()
		var cube: DerbyCube = old_list[extract_i]
		new_list[i] = cube
		# Copy the current element to the last one then remove it
		old_list[extract_i] = old_list[-1]
		old_list.remove_at(old_list.size() - 1)
	
	var params: Dictionary = {
		"new_cube_menu_list": new_list
	}
	for cube_name: String in Outside_CellList.player_dict:
		Outside_CellList.player_dict[cube_name].update_before_roll(params)

	if animating:
		var tween: Tween = create_tween().set_parallel()
		for i: int in range(new_list.size()):
			tween.tween_property(new_list[i], "position:y", i * 100.0, 1.0 / SimulatorScreen.move_speed)	\
				.set_trans(Tween.TRANS_SINE)	\
				.set_ease(Tween.EASE_IN_OUT)
	else:
		for i: int in range(new_list.size()):
			new_list[i].position.y = i * 100.0
	
	Outside_SimulatorScreen.cube_menu_list = new_list



func _on_order_timer_timeout() -> void:
	if stopping:
		return
	Outside_StateMachine.set_current_state("StateMoveEach")


