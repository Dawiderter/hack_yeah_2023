extends Node2D

@export var enemy_scenes: Array[PackedScene] 
@export var player: Node2D
@export var timer: Timer

var current_time = 895

var enemy_low = 0
var enemy_high = 1

func _process(delta):
	$player_position.position = player.position
	
	if current_time == 400:
		enemy_low = 1
		enemy_high = 2
	if current_time == 200:
		enemy_low = 2
		enemy_high = 3
	
	var time_left = timer.time_left
	if current_time > ceil(time_left):
		spawn_enemy(enemy_low)
		spawn_enemy(0)
		current_time = ceil(time_left) - 1
	
	if int(ceil(current_time - 1)) % 20 == 0:
		var count = ceil(600 - ceil(current_time))
		print(count)
		for i in range(count):
			spawn_enemy(enemy_high - 1)
		for i in range(count / 2):
			spawn_enemy(enemy_high)
		current_time = current_time - 1

func spawn_enemy(number):
	var enemy = enemy_scenes[number].instantiate()
	var enemy_location = get_node("player_position/enemy_path/enemy_spawn_location")
	enemy_location.progress_ratio = randf()

	enemy.target = $player_position

	enemy.global_position = enemy_location.global_position

	add_child(enemy)

