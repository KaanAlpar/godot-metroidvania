extends "res://Player/Projectile.gd"

const BRICK_LAYER_BIT = 4

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

func _on_Hitbox_area_entered(area):
	._on_Hitbox_area_entered(area)
	Events.emit_signal("add_screenshake", 0.25, 0.5)

func _on_Hitbox_body_entered(body):
	if body.get_collision_layer_bit(BRICK_LAYER_BIT):
		body.queue_free()
		Utils.instance_scene_on_main(EnemyDeathEffect, body.global_position + Vector2(8,11))
		
	Events.emit_signal("add_screenshake", 0.1, 0.5)
	._on_Hitbox_body_entered(body)