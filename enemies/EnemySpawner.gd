extends Node3D

@export var spawn_rate: int = 5
@export var enemy_scene: PackedScene
var wave = 1

signal enemy_spawned(enemy: Enemy)

func _on_timer_timeout():
	var offset = 0
	for i in range(0, wave):
		var enemy = enemy_scene.instantiate()
		enemy.money_value = wave
		enemy.health *= wave
		get_parent().add_child(enemy)
		enemy.global_position = global_position
		enemy.global_position.x += offset
		offset += 2
		enemy.move_and_slide()
		enemy_spawned.emit(enemy)
	$Timer.start(spawn_rate)