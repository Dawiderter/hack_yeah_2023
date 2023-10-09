extends Node2D

@export var radius: float = 200
@export var angular_speed : float = 1

@onready var sprite: AnimatedSprite2D = $sprite

var time = 0
@export var starting_damage = 50
@export var starting_speed = 2
@export var starting_range_radius = 80

func damage_times(x):
	$hurtbox.change_damage(starting_damage * x)

func cooldown_times(x):
	angular_speed = starting_speed * x

func range_times(x):
	radius = starting_range_radius * x

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_times(1)
	cooldown_times(1)
	range_times(1)
	sprite.play("move")

func change_damage(new_damage):
	$hurtbox.change_damage(new_damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * angular_speed
	time = fmod(time, 2*PI)

	position = Vector2(cos(time), sin(time)) * radius 

	if time > PI:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
