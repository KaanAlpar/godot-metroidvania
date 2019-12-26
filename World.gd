extends Node

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()