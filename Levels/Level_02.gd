extends "res://Levels/Level.gd"

const PLAYER_BIT = 0
const WORLD_BIT = 1

onready var boss_enemy = $BossEnemy
onready var block_door = $BlockDoor

func _ready():
	activate_boss(false)

func activate_boss(flag):	
	boss_enemy.visible = flag
	boss_enemy.active = flag

func set_block_door(active):
	block_door.visible = active
	block_door.set_collision_mask_bit(PLAYER_BIT, active)
	block_door.set_collision_layer_bit(WORLD_BIT, active)

func _on_Trigger_area_triggered():
	if not SaverAndLoader.custom_data.boss_defeated:
		set_block_door(true)
		activate_boss(true)

func _on_BossEnemy_died():
	set_block_door(false)	