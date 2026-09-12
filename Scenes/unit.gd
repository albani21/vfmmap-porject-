extends CharacterBody3D

var field: VFNField
@export var speed := 5.0

var target_position := Vector3(0, 1.55, 0)


func _physics_process(_delta: float) -> void:
	if field == null:
		velocity = Vector3.ZERO
		return

	var to_target := target_position - global_position
	to_target.y = 0.0

	# Stop when close enough to target.
	if to_target.length() < 0.5:
		velocity = Vector3.ZERO
		return

	var direction := field.get_vector_world(global_position)
	direction.y = 0.0

	if direction.length_squared() > 0.001:
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector3.ZERO
