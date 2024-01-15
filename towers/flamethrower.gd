extends Node3D

@export var head: Node3D
@export var flame_collider: Area3D
@export var flame_particles: GPUParticles3D

var target: Enemy
var targets: Array[Node3D] = []
@onready var timer: Timer = Timer.new()

func _ready():
	add_child(timer)
	timer.connect("timeout", damage_timer)

func damage_timer():
	if not target:
		return
	# damage each target in flame collider
	for body in flame_collider.get_overlapping_bodies():
		if not body is Enemy:
			continue
		body.damage(1)

	timer.start(0.5)

func _on_area_3d_body_entered(body:Node3D):
	if not body is Enemy:
		return
	targets.append(body)
	flame_particles.emitting = true
	if target == null:
		timer.start(0.5)
		target = body

func _on_area_3d_body_exited(body:Node3D):
	targets.erase(body)
	if targets.size() > 0:
		target = targets[0]
	else:
		target = null
		flame_particles.emitting = false
		timer.stop()

func _physics_process(delta):
	if not target:
		head.rotate_y(delta * 5)
		return
	
	# Make head "look at" target but slightly ahead
	var target_pos = target.global_transform.origin + target.velocity * 0.1
	var target_dir = target_pos - head.global_transform.origin
	head.look_at(head.global_transform.origin + target_dir, Vector3.UP, true)
