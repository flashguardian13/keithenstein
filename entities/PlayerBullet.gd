extends Area2D

# Attributes
var velocity:Vector2 = Vector2(0, 0)
var lifespan:float = 0.5
var speed:float = 600.0

func _ready():
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	lifespan -= delta
	if lifespan <= 0:
		queue_free()
	
	position = position + velocity * delta

func set_direction(dir):
	velocity = dir * speed

