extends Node2D

@export var enemy_scenes: Array[PackedScene] 
@export var player: Node2D
@export var timer: Timer

var enemy_low = 0
var enemy_high = 1

var last_spawned = 895

func _process(delta):
	$player_position.position = player.position
	
	var time_left = timer.time_left
	var current_time = ceil(time_left)
	
	if current_time <= 260:
		enemy_low = 1
		enemy_high = 2
	if current_time <= 100:
		enemy_low = 2
		enemy_high = 3
		
	var spawned = false
	
	if last_spawned - current_time >= 2:
		spawn_enemy(enemy_low)
		spawn_enemy(0)
		spawned = true
	
	if last_spawned != current_time and int(current_time) % 20 == 0:
		var count = ceil(480 - ceil(current_time))
		print(count)
		for i in range(count / 2):
			spawn_enemy(enemy_high - 1)
		for i in range(count / 4):
			spawn_enemy(enemy_high)
		spawned = true
		
	if last_spawned != current_time and int(current_time) % 120 == 0:
		var count = ceil(480 - ceil(current_time))
		print(count)
		for i in range(count / 2):
			spawn_enemy(enemy_high - 1)
		for i in range(count / 2):
			spawn_enemy(enemy_high)
		spawned = true
		
	if spawned:
		last_spawned = current_time

func spawn_enemy(number):
	var enemy = enemy_scenes[number].instantiate()
	var enemy_location = get_node("player_position/enemy_path/enemy_spawn_location")
	enemy_location.progress_ratio = randf()

	enemy.target = $player_position

	enemy.global_position = enemy_location.global_position

	add_child(enemy)

