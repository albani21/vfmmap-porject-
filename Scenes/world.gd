extends Node3D

@onready var vfn_map: VFNMap = $VectorMap

var field: VFNField


func _ready() -> void:
	await get_tree().process_frame

	var image: Image = preload("res://heightMap/protoMapHeightMap.png").get_image()

	vfn_map.field_scale = 0.7601
	vfn_map.height_scale = 22.06
	vfn_map.position = Vector3(-43.25, 0.0, -44.33)

	vfn_map.create_from_image(image)

	field = vfn_map.create_field()

	# Target
	var target_position := Vector3(0, 5, 0)
	field.add_target_from_world(target_position)

	# Terrain climbing
	field.climb_factor = 4.0
	field.climb_cutoff = 0.25

	field.drop_factor = 4.0
	field.drop_cutoff = 0.25

	print("Starting VFN calculation...")

	field.calculate_threaded(_field_finished)


func _field_finished(success: bool) -> void:
	if not success:
		print("VFN calculation failed")
		return

	print("VFN ready!")

	for unit in get_tree().get_nodes_in_group("units"):
		unit.field = field
		print("Field assigned to: ", unit.name)
