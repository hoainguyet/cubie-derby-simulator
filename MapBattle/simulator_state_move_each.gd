extends SimulatorState



var reaching_end: bool = false
var index: int = 0
var cube_menu_list: Array = []



func activate() -> void:
	if stopping:
		return
	cube_menu_list = Outside_SimulatorScreen.cube_menu_list
	index = 0
	move_cube()



func move_cube() -> void:
	
	if index >= cube_menu_list.size():
		$OrderTimer.wait_time = 1.0 / SimulatorScreen.move_speed
		$OrderTimer.start()
		return

	if stopping:
		return

	Outside_SimulatorScreen.set_roll_active(cube_menu_list[index].cube_name, true)
	if Outside_CellList.move_cube_and_above(index, cube_menu_list[index].cube_name):
		reaching_end = true
		$OrderTimer.wait_time = 1.0 / SimulatorScreen.move_speed
		$OrderTimer.start()
		return

	$TurnTimer.wait_time = 1.0 / SimulatorScreen.move_speed
	$TurnTimer.start()



func reset() -> void:
	reaching_end = false



func _on_order_timer_timeout() -> void:
	if stopping:
		return
	if reaching_end:
		Outside_StateMachine.set_current_state("StateNothing")
		Outside_SimulatorScreen.set_game_over()
	else:
		Outside_StateMachine.set_current_state("StateSetupChar")



func _on_turn_timer_timeout() -> void:
	if stopping:
		return
	Outside_SimulatorScreen.set_roll_active(cube_menu_list[index].cube_name, false)
	index += 1
	move_cube()


