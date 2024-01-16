extends Node

@export var turret_scene: PackedScene
@export_range(1, 1000) var depth := 10.0
@export var mapSize: int
@export var camera: Camera3D
@export var turret_price: int = 5

var building = false
var preview_turret: Node3D

func begin_building():
	if %GameManager.money < turret_price:
		return
	%GameManager.money -= 5
	building = true
	preview_turret = turret_scene.instantiate()
	get_parent().add_child(preview_turret)

func _physics_process(delta):
	if building:
		var mouse_pos = get_viewport().get_mouse_position()
		var cursor_pos_g = camera.project_position(mouse_pos, depth)
		cursor_pos_g.y = 0
		cursor_pos_g.x = clamp(cursor_pos_g.x, 0, mapSize)
		cursor_pos_g.z = clamp(cursor_pos_g.z, 0, mapSize)
		preview_turret.position = cursor_pos_g

func _input(event):
	if building and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			building = false
			preview_turret.preview = false
			preview_turret = null
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			building = false
			preview_turret.queue_free()
			preview_turret = null

func _on_buy_turret_button_pressed():
	begin_building()
