extends Area2D

# Attributes
var speed:float = 200

func _ready():
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	var dir:Vector2 = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		dir += Vector2(1, 0)
	if Input.is_action_pressed("ui_left"):
		dir += Vector2(-1, 0)
	if Input.is_action_pressed("ui_down"):
		dir += Vector2(0, 1)
	if Input.is_action_pressed("ui_up"):
		dir += Vector2(0, -1)
	dir = dir.normalized()
	var move = dir * speed * delta
	position += move
