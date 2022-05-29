extends Area2D

# Attributes

var speed:float = 200
var facing:Vector2 = Vector2(0, 1)
var shot_cooldown:float = 0.0
var shot_cooldown_time:float = 0.25

# Signals

signal shoot

# Common Events

func _ready():
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	var move_dir:Vector2 = update_facing()
	process_movement(move_dir, delta)
	process_shooting(delta)

# Other Functions

func update_facing():
	var move_dir:Vector2 = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		move_dir += Vector2(1, 0)
	if Input.is_action_pressed("ui_left"):
		move_dir += Vector2(-1, 0)
	if Input.is_action_pressed("ui_down"):
		move_dir += Vector2(0, 1)
	if Input.is_action_pressed("ui_up"):
		move_dir += Vector2(0, -1)
	move_dir = move_dir.normalized()
	
	if !(move_dir.x == 0 && move_dir.y == 0):
		facing = move_dir
	
	return move_dir
	
func process_movement(move_dir, delta):
	var move = move_dir * speed * delta
	position += move
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)

func process_shooting(delta):
	if shot_cooldown > 0:
		shot_cooldown -= delta
	
	if Input.is_action_pressed("ui_select") && shot_cooldown <= 0:
		shot_cooldown = shot_cooldown_time
		emit_signal("shoot", position, facing)

func _on_area_shape_entered(area_rid, area:Area2D, area_shape_index, local_shape_index):
	if area.is_in_group("mobs"):
		print("player hit mob")
