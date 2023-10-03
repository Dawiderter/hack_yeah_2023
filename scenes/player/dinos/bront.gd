extends Node2D

@export var player_keep_range: float

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var attack : PackedScene = preload("res://scenes/player/dinos/bront_attack.tscn")
@onready var cooldown : Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func change_damage(new_damage):
	attack.change_damage(new_damage)

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
	new_attack.position = global_position 
	new_attack.position += Vector2.RIGHT * (-1 if sprite.flip_h else 1) * 30
	new_attack.start_wave(Vector2.RIGHT * (-1 if sprite.flip_h else 1))
	
func _on_timer_timeout():
	play_attack()
