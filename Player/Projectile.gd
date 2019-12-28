extends Node2D

const ExplosionEffect = preload("res://Effects/ExplosionEffect.tscn")

var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta

# warning-ignore:unused_argument
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

# warning-ignore:unused_argument
func _on_Hitbox_body_entered(body):
	create_explosion_effect()
	queue_free()

# warning-ignore:unused_argument
func _on_Hitbox_area_entered(area):
	create_explosion_effect()
	queue_free()

func create_explosion_effect():
	Utils.instance_scene_on_main(ExplosionEffect, global_position)	