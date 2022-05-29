extends Area2D

# Attributes
var speed:float = 100
var behaviors = ["stand", "right", "down", "left", "up"]
var current_behavior:String = "stand"
var behavior_change_cooldown:float = 0
var behavior_change_time_fixed:float = 1
var behavior_change_time_random:float = 1

func _ready():
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	behavior_change_cooldown -= delta
	if behavior_change_cooldown <= 0:
		behavior_change_cooldown += behavior_change_time_fixed + randf() * behavior_change_time_random
		current_behavior = behaviors[randi() % behaviors.size()]
	
	if current_behavior == "stand":
		return
	
	var dir:Vector2 = Vector2(0, 0)
	if current_behavior == "right":
		dir += Vector2(1, 0)
	elif current_behavior == "left":
		dir += Vector2(-1, 0)
	elif current_behavior == "down":
		dir += Vector2(0, 1)
	elif current_behavior == "up":
		dir += Vector2(0, -1)
	dir = dir.normalized()
	
	var move = dir * speed * delta
	position += move
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("players"):
		print("mob hit player")
	if area.is_in_group("player_bullets"):
		queue_free()
