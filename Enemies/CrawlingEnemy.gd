extends "res://Enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1}

export (DIRECTION) var WALKING_DIRECTION = DIRECTION.RIGHT

onready var floor_cast = $FloorCast
onready var wall_cast = $WallCast

func _ready():
	wall_cast.cast_to.x *= WALKING_DIRECTION

func _physics_process(delta):
	if wall_cast.is_colliding():
		global_position = wall_cast.get_collision_point()
		var normal = wall_cast.get_collision_normal()
		rotation = normal.rotated(deg2rad(90)).angle()
	else:
		floor_cast.rotation_degrees = -MAX_SPEED * 10 * WALKING_DIRECTION * delta
		if floor_cast.is_colliding():
			global_position = floor_cast.get_collision_point()
			var normal = floor_cast.get_collision_normal()
			rotation = normal.rotated(deg2rad(90)).angle()
		else:
			rotation_degrees += 20 * WALKING_DIRECTION