extends Node2D

@onready var sprite: AnimatedSprite2D = $sprite

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
