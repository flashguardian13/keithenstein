extends Node2D

# Game Entity Scenes

export(PackedScene) var player_scene
export(PackedScene) var mob_scene

# Game entities

var player:Area2D

# Common Events

func _ready():
	spawn_player()
	spawn_mob()

#func _process(delta):
#	pass

# Spawn and remove game entities

func spawn_player(spawn_location = "random"):
	player = player_scene.instance()
	if spawn_location == "center":
		player.position.x = get_viewport().size.x * 0.5
		player.position.y = get_viewport().size.y * 0.5
	else:
		player.position.x = rand_range(0, get_viewport_rect().size.x)
		player.position.y = rand_range(0, get_viewport_rect().size.y)
	add_child(player)

func spawn_mob():
	var mob = mob_scene.instance()
	
	var spawn_x = rand_range(0, get_viewport().size.x)
	var spawn_y = rand_range(0, get_viewport().size.y)
	var side = randi() % 4
	if side == 0:
		spawn_x = 0
		mob.current_behavior = "right"
	elif side == 1:
		spawn_x = get_viewport().size.x
		mob.current_behavior = "left"
	elif side == 2:
		spawn_y = 0
		mob.current_behavior = "down"
	elif side == 3:
		spawn_y = get_viewport().size.y
		mob.current_behavior = "up"
	mob.behavior_change_cooldown = 2.0
	mob.position.x = spawn_x
	mob.position.y = spawn_y
	
	add_child(mob)
