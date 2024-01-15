extends Node

var money = 0:
	get:
		return money
	set(val):
		money = val
		get_node("/root/Game/UI/Control/StatPanel/MoneyLabel").text = "[font_size=30]Money: %s" % str(money)

var wave = 1
var kills = 0
var number_spawned = 0

func _on_enemy_killed(enemy: Enemy):
	kills += 1
	money += enemy.money_value
	get_node("/root/Game/UI/Control/StatPanel/KillsLabel").text = "[font_size=30]Kills: %s" % str(kills) 

func _on_enemy_spawned(enemy: Enemy):
	number_spawned += 1
	if number_spawned % (5 * int(pow(wave, 2))) == 0:
		wave += 1
		get_node("/root/Game/UI/Control/WavePanel/Label").text = "[font_size=30][center][color=black]Wave %s" % str(wave)
		%EnemySpawner.wave = wave
	enemy.connect("killed", _on_enemy_killed)
