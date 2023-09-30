extends CharacterBody2D

@export var SPEED = 200.0

func _physics_process(delta):
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")

	if not direction.is_zero_approx():
		direction = direction.normalized()

	velocity = direction * SPEED

	move_and_slide()
