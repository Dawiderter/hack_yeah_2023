extends Node2D

@export var player_keep_range: float

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var attack : PackedScene = preload("res://scenes/player/dinos/bront_attack.tscn")
@onready var cooldown : Timer = $Timer
@export var starting_damage = 10
@export var starting_speed = 3
@export var starting_wave_speed = 10
v  ar current_damage
var current_wave_speed

func _ready():
	damage_times(1)
	cooldown_times(1)
	range_times(1)

func damage_times(x):
	current_damage = starting_damage * x

func cooldown_times(x):
	cooldown.wait_time = starting_speed * x

func range_times(x):
	current_wave_speed = starting_wave_speed * x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false

	var during_attack = sprite.is_playing() && sprite.animation == "attack"
			
	if !during_attack:
		sprite.offset.x = 0
		if direction.is_zero_approx():
			sprite.play("default")
		else:
			sprite.play("move")
			
	if !direction.is_zero_approx():
		position = position.lerp(-direction * player_keep_range, 0.01)

func play_attack():
	sprite.offset.x = 16 * (-1 if sprite.flip_h else 1)
	sprite.play("attack")
	await sprite.animation_finished
	$WaveAttack.play()
	var new_attack = attack.instantiate()
	get_tree().root.add_child(new_attack)
	new_attack.change_damage(current_damage)
	new_attack.move_speed = current_wave_speed
	new_attack.position = global_position 
	new_attack.position += Vector2.RIGHT * (-1 if sprite.flip_h else 1) * 30
	new_attack.start_wave(Vector2.RIGHT * (-1 if sprite.flip_h else 1))
	
func _on_timer_timeout():
	play_attack()
