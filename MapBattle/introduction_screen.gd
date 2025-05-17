extends ColorRect



signal disappeared



func _on_button_pressed() -> void:
	disappeared.emit()


