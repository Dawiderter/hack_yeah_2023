extends Node2D

@export var enemy_scenes: Array[PackedScene] 
@export var player: Node2D
@export var timer: Timer

var current_time = 895

func _process(delta):
	var time_left = timer.time_left
	if current_time > ceil(time_left):
		spawn_enemy(0)
		spawn_enemy(0)
		current_time = ceil(time_left) - 1
	
	if int(ceil(time_left - 1)) % 20 == 0:
		var count = ceil(log(900 - ceil(time_left)))
		for i in range(count * count):
			spawn_enemy(1)

func spawn_enemy(number):
	var enemy = enemy_scenes[number].instantiate()
	var enemy_location = get_node("player_position/enemy_path/enemy_spawn_location")
	enemy_location.progress_ratio = randf()

	enemy.target = $player_position

	enemy.global_position = enemy_location.global_position

	add_child(enemy)

