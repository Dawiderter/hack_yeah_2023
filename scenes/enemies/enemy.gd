extends CharacterBody2D

@export var move_speed = 100
@export var target: Marker2D

@export var max_health: float

@onready var health = max_health
@onready var animation_tree: AnimationTree = $AnimationTree

var impulse_vel: Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = (target.position - position).normalized()

	velocity = impulse_vel + direction * move_speed

	impulse_vel = impulse_vel.lerp(Vector2.ZERO,delta)

	animation_tree["parameters/Move/blend_position"] = direction
	move_and_slide()

func _ready():
	animation_tree.active=true

func _on_hitbox_on_hit(hit_data : HitStats, source: Area2D):
	health -= hit_data.damage_dealt
	if health <= 0:
		queue_free()

	var source_pos = source.global_position
	var our_pos = global_position
	var dir = source_pos.direction_to(our_pos)

	impulse_vel = dir * hit_data.knockback_strength

