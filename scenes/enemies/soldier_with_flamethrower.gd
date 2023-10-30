extends CharacterBody2D

@export var move_speed = 20
@export var parachute_speed = 10
@export var target: Marker2D
@export var hit_time = 2

@export var meat: PackedScene

@export var max_health: float

@onready var health = max_health
@onready var animation_tree: AnimationTree = $AnimationTree

var timer = 0.0
var impulse_vel: Vector2 = Vector2.ZERO
var speed = move_speed

var parachute_on = false
var throwing: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer > 0.0:
		timer -= delta
		modulate = Color.from_hsv(0, (1 - health/max_health) * timer, 1)
	var direction = (target.position - position).normalized()
	if parachute_on && !$point.is_colliding():
		remove_parachute()

	velocity = impulse_vel + direction * speed

	impulse_vel = impulse_vel.lerp(Vector2.ZERO,delta)

	animation_tree["parameters/Move/blend_position"] = direction
	move_and_slide()

func put_parachute():
	parachute_on = true
	set_collision_mask_value(1, false)
	set_collision_layer_value(1, false)
	speed = parachute_speed
	print("PARACHUTE")

func remove_parachute():
	parachute_on = false
	set_collision_mask_value(1, true)
	set_collision_layer_value(1, true)
	speed = move_speed

func _ready():
	$point.force_raycast_update()
	if $point.is_colliding():
		put_parachute()
	animation_tree.active=true

func _on_hitbox_on_hit(hit_data : HitStats, source: Area2D):
	health -= hit_data.damage_dealt
	timer = hit_time
	if health <= 0:
		var droped_meat = meat.instantiate()
		droped_meat.global_position = global_position
		get_parent().add_child(droped_meat)
		queue_free()

	var source_pos = source.global_position
	var our_pos = global_position
	var dir = source_pos.direction_to(our_pos)

	impulse_vel = dir * hit_data.knockback_strength



func _on_cooldown_timeout():
	for i in range(10):
		var bullet = preload("res://scenes/enemies/flame_bullet.tscn").instantiate()
		get_parent().add_child(bullet)

		var source_pos = target.global_position
		var our_pos = global_position
		var dir = our_pos.direction_to(source_pos)

		var randomness = randfn(0.0, 0.2)

		dir = dir.rotated(randomness)

		bullet.position = position
		bullet.get_node("gun_bullet").direction = dir
		var time = randf_range(25,75)
		bullet.get_node("gun_bullet").speed = time
		bullet.get_node("gun_bullet").get_node("lifetime").start(2 * time / 75)
	
