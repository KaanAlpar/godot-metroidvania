extends Area2D

# warning-ignore:unused_class_variable
export (Resource) var connection = null
# warning-ignore:unused_class_variable
export (String, FILE, "*.tscn") var new_level_path = ""

var active = true

func _on_Door_body_entered(Player):
	if active:
		Player.emit_signal("hit_door", self)
		active = false
