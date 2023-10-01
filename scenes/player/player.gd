extends CharacterBody2D

@export var SPEED = 200.0
@export var camera_speed = 1.0
@export var camera_distance = 25.0

var level = 1

func _physics_process(delta):
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")

	if not direction.is_zero_approx():
		direction = direction.normalized()
	
	var camera_position = direction * camera_distance
	velocity = direction * SPEED
	$Camera2D.position += (camera_position - $Camera2D.position) * camera_speed * delta

	move_and_slide()


func _on_hurtbox_area_entered(area:Area2D):
	pass


func _on_hitbox_on_hit(damage, source):
	print(damage)

func level_up():
	pass
