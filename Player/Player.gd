extends KinematicBody2D

const DustEffect = preload("res://Effects/DustEffect.tscn")
const JumpEffect = preload("res://Effects/JumpEffect.tscn")
const PlayerBullet = preload("res://Player/PlayerBullet.tscn")

var PlayerStats = ResourceLoader.PlayerStats

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25
export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46
export (int) var BULLET_SPEED = 250

var invincible = false setget set_invincible
var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var just_jumped = false
var double_jump = true

onready var sprite = $Sprite
onready var sprite_animator = $SpriteAnimator
onready var blink_animator = $BlinkAnimator
onready var coyote_jump_timer = $CoyoteJumpTimer
onready var fire_bullet_timer = $FireBulletTimer
onready var gun = $Sprite/PlayerGun
onready var muzzle = $Sprite/PlayerGun/Sprite/Muzzle

func set_invincible(value):
	invincible = value

func _ready():
	PlayerStats.connect("player_died", self, "_on_died")

func _physics_process(delta):
	just_jumped = false
	var input_vector = get_input_vector()
	apply_horizontal_force(input_vector, delta)
	apply_friction(input_vector)
	update_snap_vector()
	jump_check()
	apply_gravity(delta)
	update_animations(input_vector)
	move()
	
	if Input.is_action_pressed("fire") and fire_bullet_timer.time_left == 0:
		fire_bullet()

func fire_bullet():
	var bullet = Utils.instance_scene_on_main(PlayerBullet, muzzle.global_position)
	bullet.velocity = Vector2.RIGHT.rotated(gun.rotation) * BULLET_SPEED
	bullet.velocity.x *= sprite.scale.x
	bullet.rotation = bullet.velocity.angle()
	fire_bullet_timer.start()

func create_dust_effect():
	var dust_position = global_position
	dust_position.x += rand_range(-4, 4)
	Utils.instance_scene_on_main(DustEffect, dust_position)

func create_jump_effect():
	Utils.instance_scene_on_main(JumpEffect, global_position)	

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector

func apply_horizontal_force(input_vector, delta):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func apply_friction(input_vector):
	if input_vector.x == 0 and is_on_floor():
		motion.x = lerp(motion.x, 0, FRICTION)

func update_snap_vector():
	if is_on_floor():
		snap_vector = Vector2.DOWN

func jump_check():
	if is_on_floor() or coyote_jump_timer.time_left > 0:
		if Input.is_action_just_pressed("jump"):
			jump(JUMP_FORCE)
			just_jumped = true
	else:
		# Jump released early it wont be as high as a max jump
		if Input.is_action_just_released("jump") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if Input.is_action_just_pressed("jump") && double_jump:
			jump(JUMP_FORCE * 0.75)
			double_jump = false

func jump(force):
	motion.y = -force
	create_jump_effect()
	snap_vector = Vector2.ZERO

func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)

func update_animations(input_vector):
	sprite.scale.x =  sign(get_local_mouse_position().x)	
	if input_vector.x != 0:
		sprite_animator.play("Run")
		sprite_animator.playback_speed = input_vector.x * sprite.scale.x
	else:
		sprite_animator.playback_speed = 1
		sprite_animator.play("Idle")
	
	if not is_on_floor():
		sprite_animator.play("Jump")

func move():
	var was_on_floor = is_on_floor()
	var was_in_air = not was_on_floor
	
	var last_motion = motion
	var last_position = position
	
	motion = move_and_slide_with_snap(motion, snap_vector * 4, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))
	# Landing
	if was_in_air and is_on_floor():
		motion.x = last_motion.x
		create_jump_effect()
		double_jump = true
		
	# Just left ground/Just fell off an edge
	if was_on_floor and not is_on_floor() and not just_jumped:
		motion.y = 0
		position.y = last_position.y
		coyote_jump_timer.start()

	# Prevent sliding (hack)
	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
		position.x = last_position.x
# End of move()

func _on_Hurtbox_hit(damage):
	if not invincible:
		PlayerStats.health -= damage
		blink_animator.play("Blink")

func _on_died():
	queue_free()
















