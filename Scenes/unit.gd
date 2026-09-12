extends CharacterBody3D

var field: VFNField
@export var speed := 5.0


func _physics_process(_delta):
	if field == null:
		return

	var direction := field.get_vector_smooth_world(global_position)

	if direction.length_squared() > 0.001:
		velocity = direction * speed
		move_and_slide()
