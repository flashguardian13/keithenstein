extends Node2D

# Game Entity Scenes

export(PackedScene) var player_scene
export(PackedScene) var mob_scene
export(PackedScene) var player_bullet_scene
export(PackedScene) var water_scene

# Game entities

var player:KinematicBody2D

# Game values

var mob_spawn_cooldown:float = 0
export var mob_spawn_cooldown_time:float = 1.0
var flooding_cooldown:float = 0
export var flooding_cooldown_time:float = 10.0
var island_rows:int = 6
var island_columns:int = 10
var flood_map

# Helpers

func column_width():
	return get_viewport_rect().size.x / island_columns

func row_width():
	return get_viewport_rect().size.y / island_rows

# Common Events

func _ready():
	flooding_cooldown = flooding_cooldown_time
	
	if flood_map == null:
		flood_map = []
		for fy in island_rows:
			var row = []
			for fx in island_columns:
				row.push_back(false)
			flood_map.push_back(row)
			
	spawn_player()

func _process(delta):
	if mob_spawn_cooldown > 0:
		mob_spawn_cooldown -= delta
	
	if mob_spawn_cooldown <= 0:
		mob_spawn_cooldown = mob_spawn_cooldown_time
		spawn_mob()
	
	if flooding_cooldown > 0:
		flooding_cooldown -= delta
	
	if flooding_cooldown <= 0:
		flooding_cooldown = flooding_cooldown_time
		flood_island()

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
	var mob:Area2D = mob_scene.instance()
	
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
	var bullet:Area2D = player_bullet_scene.instance()
	bullet.position = pos
	bullet.set_direction(dir)
	bullet.add_to_group("player_bullets")
	add_child(bullet)

func spawn_water(fx, fy):
	var water:StaticBody2D = water_scene.instance()
	water.position.x = (fx + 0.5) * column_width()
	water.position.y = (fy + 0.5) * row_width()
	water.z_index = -1
	water.fit_to(column_width(), row_width())
	water.add_to_group("water")
	add_child(water)
	flood_map[fy][fx] = true

# Game Events

func can_flood(fx, fy):
	# Can always flood around the edges
	if fx == 0 || fx == island_columns - 1 || fy == 0 || fy == island_rows - 1:
		return true
	
	# Cannot flood if already flooded
	if flood_map[fy][fx]:
		return false
	
	# Can flood if adjacent to another flooded chunk
	if flood_map[fy-1][fx] || flood_map[fy+1][fx] || flood_map[fy][fx-1] || flood_map[fy][fx+1]:
		return true
	
	# Otherwise, cannot flood
	return false

func flood_island():
	var floodable_chunks = []
	for fy in island_rows:
		for fx in island_columns:
			if can_flood(fx, fy):
				floodable_chunks.push_back([fx, fy])
	
	var chunk = floodable_chunks[randi() % floodable_chunks.size()]
	spawn_water(chunk[0], chunk[1])
