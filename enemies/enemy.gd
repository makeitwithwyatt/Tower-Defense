class_name Enemy extends CharacterBody3D

@export var speed = 12
@export var health = 10
@export var click_particle_scene: PackedScene
@onready var path_points: Array[Node]
@onready var Camera: Camera3D = get_node("/root/Game/Camera")
@onready var health_bar: ProgressBar = $SubViewport/HealthBar

var path_point_index = 0
var state = "moving"
var death_timer = Timer.new()
var money_value = 1

signal killed(enemy: Enemy)

func _ready():
	add_child(death_timer)
	path_points = get_node("/root/Game/Terrain/PathPoints").get_children()
	$AnimationPlayer.play("Running_SwordsMen")
	if health_bar:
		health_bar.max_value = health
		health_bar.value = health

func _physics_process(delta):
	match state:
		"moving":
			move(delta)
		["ready_attack", "attacking"]:
			attack(delta)
		"dead":
			position.y -= 0.01

func move(delta):
	var path_point: Node3D = path_points[path_point_index]
	var direction = (path_point.position - position).normalized()
	velocity = direction * speed
	move_and_slide()
	look_at(path_point.position, Vector3.UP, true)
	if position.distance_to(path_point.position) < 1:
		path_point_index += 1
	if path_point_index >= path_points.size():
		state = "ready_attack"

func attack(delta):
	if state != "attacking":
		$AnimationPlayer.play("Atack_SwordsMen")
		state = "attacking"
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var ray_origin = Camera.project_ray_origin(event.position)
			var ray_direction = Camera.project_ray_normal(event.position)
			var ray_length = 100
			var ray_end = ray_origin + ray_direction * ray_length
			var space_state = get_world_3d().direct_space_state
			var params = PhysicsRayQueryParameters3D.new()
			params.from = ray_origin
			params.to = ray_end
			params.exclude = []
			params.collision_mask = 1
			var result = space_state.intersect_ray(params)
			if result:
				if result.collider == self:
					damage(1)

func damage(amount: int):
	if health <= 0:
		return
	var particles = click_particle_scene.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.emitting = true
	health -= amount
	if health_bar:
		health_bar.value = health
	if health <= 0:
		if health_bar:
			$HealthBar.queue_free()
			remove_child($HealthBar)
		killed.emit(self)
		state = "dead"
		$AnimationPlayer.play("Death_SwordsMen")
		death_timer.start(3)
		death_timer.connect("timeout", _on_death_complete)
		$CollisionShape3D.disabled = true

func _on_death_complete():
	queue_free()
