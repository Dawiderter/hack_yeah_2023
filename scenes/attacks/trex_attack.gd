extends Node2D

@onready var left_shape: CollisionShape2D = $hurtbox/LeftShape
@onready var right_shape: CollisionShape2D = $hurtbox/RightShape
@onready var duration_timer: Timer = $duration
@onready var cooldown_timer: Timer = $cooldown
@onready var sprite: AnimatedSprite2D = $sprite

@export var range_length: float
@export var range_width: float

@export var duration: float
@export var cooldown: float


# Ustawiane przy drugim ataku, żeby powiedzieć, że skończyliśmy naszą rutynę ataków
var should_attack_go_on_cooldown: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_range_length(range_length)
	set_range_width(range_width)


func set_range_width(_range_width: float):
	range_width = _range_width
	left_shape.shape.radius = range_width / 2
	right_shape.shape.radius = range_width / 2

func set_range_length(_range_length: float):
	range_length = _range_length
	left_shape.shape.height = range_length
	right_shape.shape.height = range_length
	left_shape.position.x = -range_length / 2
	right_shape.position.x = range_length / 2
	
func draw_anim(on_right: bool):
	sprite.position.x = (5 + range_length / 2) * (1 if on_right else -1)
	sprite.scale.x = 1.2 * range_length / 32
	sprite.scale.y = 1.2 * range_width / 32
	sprite.flip_h = on_right
	sprite.visible = true
	sprite.stop()
	sprite.play("default", 2 / duration)

func _on_duration_timeout():
	if should_attack_go_on_cooldown:
		sprite.visible = false
		left_shape.set_deferred("disabled", true)
		cooldown_timer.start(cooldown)
		should_attack_go_on_cooldown = false
	else:
		draw_anim(false)
		left_shape.set_deferred("disabled", false)
		right_shape.set_deferred("disabled", true)

		duration_timer.start(duration / 2)
		should_attack_go_on_cooldown = true

func _on_cooldown_timeout():
	draw_anim(true)
	right_shape.set_deferred("disabled", false)
	duration_timer.start(duration / 2)
