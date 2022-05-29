extends Node2D

# Game Entity Scenes
export(PackedScene) var player_scene

# Game entities
var player:Area2D

# Common Events
func _ready():
	spawn_player()

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
