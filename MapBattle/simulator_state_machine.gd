extends Node



@export var Outside_SimulatorScreen: Node2D
@export var Outside_CellList: Node2D

@export var curr_state: SimulatorState = null
var state_dict: Dictionary = {}



func set_current_state(value: String) -> void:
	curr_state = state_dict[value]
	curr_state.stopping = false
	curr_state.activate()



func restart_machine() -> void:
	for state_name: String in state_dict:
		state_dict[state_name].stopping = true
		state_dict[state_name].reset()



func _ready() -> void:
	var node_list: Array = get_children()
	for node in node_list:
		state_dict[node.name] = node
		node.Outside_SimulatorScreen = Outside_SimulatorScreen
		node.Outside_CellList = Outside_CellList
		node.Outside_StateMachine = self


