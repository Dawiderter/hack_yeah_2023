extends Node2D

@export var enemy_1_scene: PackedScene 
@export var player: Node2D

func _process(delta):
	$player_position.position = player.position
	if Input.is_action_pressed("spawn_test"):
		spawn_enemy_1()

func spawn_enemy_1():
	var enemy = enemy_1_scene.instantiate()
	var enemy_location = get_node("player_position/enemy_path/enemy_spawn_location")
	enemy_location.progress_ratio = randf()

	enemy.target = $player_position

	enemy.global_position = enemy_location.global_position

	add_child(enemy)

