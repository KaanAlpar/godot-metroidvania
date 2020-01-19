extends "res://Enemies/Enemy.gd"

const Bullet = preload("res://Enemies/EnemyBullet.tscn")

var MainInstances = ResourceLoader.MainInstances

export(int) var ACCELERATION = 70

var active = false

onready var right_wall_check = $RightWallCheck
onready var left_wall_check = $LeftWallCheck

signal died

func _process(delta):
	if active:
		chase_player(delta)

func _on_EnemyStats_enemy_died():
	emit_signal("died")
	._on_EnemyStats_enemy_died()

func chase_player(delta):
	var player = MainInstances.Player
	if player:
		var direction_to_move = sign(player.global_position.x - global_position.x)
		motion.x += ACCELERATION * delta * direction_to_move
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		global_position.x += motion.x * delta
		rotation_degrees = lerp(rotation_degrees, (motion.x / MAX_SPEED) * 10, 0.3)
		
		if ((right_wall_check.is_colliding() and motion.x > 0) or
		(left_wall_check.is_colliding() and motion.x < 0)):
			motion.x *= -0.5

func fire_bullet() -> void:
	var bullet = Utils.instance_scene_on_main(Bullet, global_position)
	var velocity = Vector2.DOWN * 50
	velocity = velocity.rotated(deg2rad(rand_range(-30, 30)))
	bullet.velocity = velocity

func _on_Timer_timeout():
	if active:
		fire_bullet()
