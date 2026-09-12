extends Node3D

@onready var vfn_map: VFNMap = $VectorMap

var field: VFNField


func _ready():
	await get_tree().process_frame

	# Your 120x120 Blender heightmap
	var image:Image = preload("uid://c51attf15oegq").get_image()
	

	# Build the VFN grid from it
	vfn_map.field_scale = 0.7601
	vfn_map.height_scale = 22.06
	vfn_map.position = Vector3(-43.25, 0.0, -44.33)

	vfn_map.create_from_image(image)

	# Create the vector field
	field = vfn_map.create_field()

	# Target position on your map
	var target_position := Vector3(0, 5, 0)

	field.add_target_from_world(target_position)

	# Make steep terrain impossible to climb
	field.climb_factor = 4.0
	field.climb_cutoff = 0.25

	field.drop_factor = 4.0
	field.drop_cutoff = 0.25

	field.calculate_threaded(_field_finished)


func _field_finished(success: bool, _field: VFNField):
	if not success:
		print("VFN calculation failed")
		return

	print("VFN ready!")

	# Give the field to all units
	for unit in get_tree().get_nodes_in_group("units"):
		unit.field = field
