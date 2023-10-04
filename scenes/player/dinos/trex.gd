extends Node2D

@onready var sprite: AnimatedSprite2D = $sprite
@export var starting_damage = 50
@export var starting_speed = 2
@export var starting_width = 80
@export var starting_length = 100

func _ready():
	damage_times(1)
	cooldown_times(1)
	range_times(1)

func damage_times(x):
	$trex_attack.change_damage(starting_damage * x)

func cooldown_times(x):
	$trex_attack.cooldown = starting_speed * x

func range_times(x):
	$trex_attack.set_range_width(starting_width * x)
	$trex_attack.set_range_length(starting_length * x)

func _process(delta):
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false

	if direction.is_zero_approx():
		sprite.play("default")
	else:
		sprite.play("move")
