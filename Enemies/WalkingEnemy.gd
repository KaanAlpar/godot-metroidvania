extends "res://Enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1}

export (DIRECTION) var WALKING_DIRECTION

var state

onready var sprite = $Sprite
onready var floor_left = $FloorLeft
onready var floor_right = $FloorRight
onready var wall_left = $WallLeft
onready var wall_right = $WallRight

func _ready():
	state = WALKING_DIRECTION
	motion.y = 8

# warning-ignore:unused_argument
func _physics_process(delta):
	match state:
		DIRECTION.RIGHT:
			motion.x = MAX_SPEED
			if not floor_right.is_colliding() or wall_right.is_colliding():
				state = DIRECTION.LEFT
			
		DIRECTION.LEFT:
			motion.x = -MAX_SPEED
			if not floor_left.is_colliding() or wall_left.is_colliding():
				state = DIRECTION.RIGHT
	
	sprite.scale.x = sign(motion.x)
	motion = move_and_slide_with_snap(motion, Vector2.DOWN * 4, Vector2.UP, true, 4, deg2rad(46))
	