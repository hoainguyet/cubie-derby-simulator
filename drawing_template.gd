extends Node2D



func _ready() -> void:
	takeScreenshot()



func takeScreenshot() -> void:
	await RenderingServer.frame_post_draw
	var img: Image = get_viewport().get_texture().get_image()
	img.save_png("screenshot.png")


