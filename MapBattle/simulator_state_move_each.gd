extends SimulatorState



var reaching_end: bool = false



func activate() -> void:
	if stopping:
		return
	move_cube()



func move_cube() -> void:

	var cube_menu_list: Array = Outside_SimulatorScreen.cube_menu_list
	for i: int in range(cube_menu_list.size()):
		if stopping:
			return
		Outside_SimulatorScreen.set_roll_active(cube_menu_list[i].cube_name, true)
		if Outside_CellList.move_cube_and_above(i, cube_menu_list[i].cube_name):
			reaching_end = true
			break
		await get_tree().create_timer(1.0 / SimulatorScreen.move_speed).timeout
		if stopping:
			return
		Outside_SimulatorScreen.set_roll_active(cube_menu_list[i].cube_name, false)

	$OrderTimer.wait_time = 1.0 / SimulatorScreen.move_speed
	$OrderTimer.start()



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


