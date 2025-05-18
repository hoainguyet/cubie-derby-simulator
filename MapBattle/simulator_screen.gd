class_name SimulatorScreen extends Node2D



var cube_menu_list: Array = []
var cube_menu_dict: Dictionary = {}
var default_player_names: Array = []

var starting: bool = true
var ending: bool = false

var dragging: bool = false
var mouse_pos_before: Vector2 = Vector2.ZERO
var pinned_pos_before: Vector2 = Vector2.ZERO
var zoom_min: float = 0.5
var zoom_max: float = 2.0
var curr_zoom: float = 1.0
var zoom_factor: float = 0.1

static var move_speed: float = 1.0

@export var GameOverScreenSample: PackedScene
@export var SelectionScreenSample: PackedScene
@export var IntroductionScreenSample: PackedScene
@export var AbilitySignSample: PackedScene
@export var DiceSample: PackedScene



# -----------------------------------------------------------------------------
# Inheritance functions
# -----------------------------------------------------------------------------

func _ready() -> void:
	default_player_names = [ "brant", "roccia", "cantarella", "cartethyia", "phoebe", "zani" ]
	set_introduction()



func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("MOUSE"):
		if not dragging:
			# mouse_holding_countdown = mouse_holding_delay
			mouse_pos_before = get_global_mouse_position()
			pinned_pos_before = $Camera2D.position
			dragging = true	

	elif event.is_action_released("MOUSE"):
		dragging = false
		$Camera2D.position.x = clamp($Camera2D.position.x, -1536.0 / 2.0, 1536.0 / 2.0)
		$Camera2D.position.y = clamp($Camera2D.position.y, -1024.0 / 2.0, 1024.0 / 2.0)
	
	elif event.is_action_pressed("ENTER"):
		await RenderingServer.frame_post_draw
		var img: Image = get_viewport().get_texture().get_image()
		img.save_png("screenshot.png")



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("SCROLL_UP"):
		clamp_camera_zoom(curr_zoom + zoom_factor)
	elif event.is_action_pressed("SCROLL_DOWN"):
		clamp_camera_zoom(curr_zoom - zoom_factor)



func _process(_delta: float) -> void:
	if dragging:
		$Camera2D.position = pinned_pos_before + (-get_global_mouse_position() + mouse_pos_before)



# -----------------------------------------------------------------------------
# Support functions
# -----------------------------------------------------------------------------

func start_battle() -> void:
	$SimulatorStateMachine.set_current_state("StateSetupChar")



func clamp_camera_zoom(new_zoom: float) -> void:
	curr_zoom = clamp(new_zoom, zoom_min, zoom_max)
	var tween: Tween = create_tween()
	tween.tween_property($Camera2D, "zoom", Vector2(curr_zoom, curr_zoom), 0.5).set_trans(Tween.TRANS_SINE)
	


func update_roll_dice(cube_name: String, dice: int) -> void:
	cube_menu_dict[cube_name].get_node("Dice").dice_value = dice
	cube_menu_dict[cube_name].get_node("Dice").active = false

func set_roll_active(cube_name: String, value: bool) -> void:
	cube_menu_dict[cube_name].get_node("Dice").active = value



func update_rank(cube_name: String, rank: int) -> void:
	cube_menu_dict[cube_name].rank = rank



func set_game_over() -> void:
	var screen: Control = GameOverScreenSample.instantiate()
	$CanvasLayer.add_child(screen)
	screen.add_rank(cube_menu_list)
	screen.again_tried.connect(_on_game_over_screen_again_tried.bind(screen))



func set_player_selection() -> void:
	for cube: DerbyCube in cube_menu_list:
		$CanvasLayer/PlayerList.remove_child(cube)
		cube.queue_free()
	cube_menu_list.clear()
	cube_menu_dict.clear()
	var screen: Control = SelectionScreenSample.instantiate()
	$CanvasLayer.add_child(screen)
	screen.update_toggled(default_player_names)
	screen.selected.connect(_on_player_selection_selected.bind(screen))



func set_introduction() -> void:
	var screen: Control = IntroductionScreenSample.instantiate()
	$CanvasLayer.add_child(screen)
	screen.disappeared.connect(_on_introduction_screen_disappeared.bind(screen))



# -----------------------------------------------------------------------------
# Signal functions
# -----------------------------------------------------------------------------

func _on_start_button_pressed() -> void:
	if starting:
		starting = false
		$CanvasLayer/ButtonList/StopButton.show()
		start_battle()
	get_tree().paused = false



func _on_stop_button_pressed() -> void:
	get_tree().paused = true



func _on_restart_button_pressed() -> void:
	starting = true
	ending = false
	$SimulatorStateMachine.restart_machine()
	$CanvasLayer/ButtonList/StopButton.hide()
	set_player_selection()



func _on_cell_list_rank_changed(cube_name: String, rank: int) -> void:
	update_rank(cube_name, rank)



func _on_game_over_screen_again_tried(screen: Control) -> void:
	# Parameters
	starting = true
	ending = false
	$SimulatorStateMachine.restart_machine()
	$CanvasLayer/ButtonList/StopButton.hide()

	$CanvasLayer.remove_child(screen)
	screen.queue_free()



func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_float():
		var new_speed: float = new_text.to_float()
		if new_speed >= 0.0:
			if new_speed > 32.0:
				move_speed = 32.0
				$CanvasLayer/LineEdit.text = str(move_speed)
			else:
				move_speed = new_speed
		else:
			$CanvasLayer/LineEdit.text = str(move_speed)
	else:
		$CanvasLayer/LineEdit.text = str(move_speed)



func _on_cell_list_ability_activated(cube_name: String) -> void:
	var ability_sign: Control = AbilitySignSample.instantiate()
	$CanvasLayer/AbilityContainer.add_child(ability_sign)
	ability_sign.set_label("Activate " + cube_name.capitalize() + " ability")
	ability_sign.disappeared.connect(_on_object_removed.bind(ability_sign, $CanvasLayer/AbilityContainer))



func _on_player_selection_selected(player_name_list: Array, screen: Control) -> void:

	for i: int in range(player_name_list.size()):
		var player_name: String = player_name_list[i]
		var sample: PackedScene = load("res://DerbyCubes/derby_cube_" + player_name + ".tscn")

		var cube: DerbyCube = sample.instantiate()
		var dice: Node2D = DiceSample.instantiate()
		$CanvasLayer/PlayerList.add_child(cube)
		cube.add_child(dice)

		dice.position = Vector2(100.0, 0.0)
		cube.position = Vector2(0.0, i * 100.0)
		dice.active = false

		cube_menu_list.append(cube)
		cube_menu_dict[player_name_list[i]] = cube

	default_player_names = player_name_list
	$CanvasLayer.remove_child(screen)
	screen.queue_free()



func _on_object_removed(node: Node, parent: Node) -> void:
	parent.remove_child(node)
	node.queue_free()



func _on_introduction_screen_disappeared(screen: Control) -> void:
	$CanvasLayer.remove_child(screen)
	screen.queue_free()
	set_player_selection()


