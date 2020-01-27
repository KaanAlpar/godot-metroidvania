extends "res://Player/Projectile.gd"

func _ready():
	SoundFX.play("Bullet", rand_range(0.6, 1.2), -10)
	set_process(false)