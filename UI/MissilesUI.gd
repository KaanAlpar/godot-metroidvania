extends HBoxContainer

var PlayerStats = ResourceLoader.PlayerStats

onready var label = $Label

func _ready():
	PlayerStats.connect("player_missiles_changed", self, "_on_player_missiles_changed")
	PlayerStats.connect("player_missiles_unlocked", self, "_on_player_missiles_unlocked")

func _on_player_missiles_changed(value):
	label.text = str(value)

func _on_player_missiles_unlocked(value):
	visible = value