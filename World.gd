extends Node

onready var current_level = $Level_00

func _ready():
	VisualServer.set_default_clear_color(Color.black)