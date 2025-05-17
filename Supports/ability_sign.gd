extends ColorRect



signal disappeared

func set_label(value: String) -> void:
	$Label.text = value
	


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	disappeared.emit()


