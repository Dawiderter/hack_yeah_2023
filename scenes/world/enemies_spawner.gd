extends Node

@export var enemy_1_scene: PackedScene 

func _on_start_delay_timeout():
	$enemy_1_spawner_timer.start()



func _on_enemy_1_spawner_timer_timeout():
	var enemy = enemy_1_scene.instantiate()
	var enemy_location = get_node("player_position/enemy_path/enemy_spawn_location")
	enemy_location.progress_ratio = randf()

	enemy.target = $player_position

	enemy.position = enemy_location.position

	add_child(enemy)

