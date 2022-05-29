extends StaticBody2D

func _ready():
	pass

#func _process(delta):
#	pass

func fit_to(column_width, row_height):
	var half_size:Vector2 = $CollisionShape2D.shape.extents
	scale.x = column_width / (2.0 * half_size.x)
	scale.y = row_height / (2.0 * half_size.y)
