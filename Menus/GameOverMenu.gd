extends CenterContainer

func _ready():
	pass

func _on_QuitButton_pressed():
	SoundFX.play("Click",1 , -30)
	get_tree().change_scene("res://Menus/StartMenu.tscn")

func _on_LoadButton_pressed():
	SoundFX.play("Click", 1, -30)
	SaverAndLoader.is_loading = true
	Music.list_stop()
	get_tree().change_scene("res://World.tscn")