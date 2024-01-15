extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@export_range(1, 1000) var depth := 10.0
@export var camera: Camera3D
@export var mapSize: int

func _process(_dt):
	var mouse_pos = get_viewport().get_mouse_position()
	var cursor_pos_g = camera.project_position(mouse_pos, depth)
	cursor_pos_g.y = 0
	cursor_pos_g.x = clamp(cursor_pos_g.x, 0, mapSize)
	cursor_pos_g.z = clamp(cursor_pos_g.z, 0, mapSize)

	global_position = cursor_pos_g
