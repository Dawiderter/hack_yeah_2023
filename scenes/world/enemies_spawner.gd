extends Node2D

@export var enemy_scenes: Array[PackedScene] 
@export var player: Node2D

func _process(delta):
	$player_position.position = player.position
	if Input.is_action_pressed("one"):
		spawn_enemy(0)
	if Input.is_action_pressed("two"):
		spawn_enemy(1)
	if Input.is_action_pressed("three"):
		spawn_enemy(2)
	if Input.is_action_pressed("four"):
		spawn_enemy(3)

func spawn_enemy(number):
	var enemy = enemy_scenes[number].instantiate()
	var enemy_location = get_node("player_position/enemy_path/enemy_spawn_location")
	enemy_location.progress_ratio = randf()

	enemy.target = $player_position

	enemy.global_position = enemy_location.global_position

	add_child(enemy)

