extends CharacterBody2D

@export var SPEED = 200.0
@export var camera_speed = 1.0
@export var camera_distance = 25.0
@export var max_health: int = 100

var health = max_health
var level = 1
var exp = 0
const level_caps: Array[int] = [10, 25, 50, 80, 120, 180, 250, 360, 500]

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
	health -= damage

	if health < 0:
		health = 0
	print(damage)

func gain_xp(xp):
	exp += xp
	var level_cap_index = min(level - 1, level_caps.size() - 1)
	if exp > level_caps[level_cap_index]:
		exp -= level_caps[level_cap_index]
		level_up()

func level_up():
	level += 1
	pass
