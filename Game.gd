extends Node2D

# Game Entity Scenes

export(PackedScene) var player_scene
export(PackedScene) var mob_scene
export(PackedScene) var player_bullet_scene

# Game entities

var player:Area2D

# Game values

var mob_spawn_cooldown:float = 0
export var mob_spawn_cooldown_time:float = 10.0

# Common Events

func _ready():
	spawn_player()
	spawn_mob()

func _process(delta):
	if mob_spawn_cooldown > 0:
		mob_spawn_cooldown -= delta
	
	if mob_spawn_cooldown <= 0:
		mob_spawn_cooldown = mob_spawn_cooldown_time
		spawn_mob()

# Spawn and remove game entities

func spawn_player(spawn_location = "random"):
	player = player_scene.instance()
	if spawn_location == "center":
		player.position.x = get_viewport().size.x * 0.5
		player.position.y = get_viewport().size.y * 0.5
	else:
		player.position.x = rand_range(0, get_viewport_rect().size.x)
		player.position.y = rand_range(0, get_viewport_rect().size.y)
	player.connect("shoot", self, "spawn_player_bullet")
	player.add_to_group("players")
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
	
	mob.add_to_group("mobs")
	add_child(mob)

func spawn_player_bullet(pos, dir):
	var bullet = player_bullet_scene.instance()
	bullet.position = pos
	bullet.set_direction(dir)
	bullet.add_to_group("player_bullets")
	add_child(bullet)
