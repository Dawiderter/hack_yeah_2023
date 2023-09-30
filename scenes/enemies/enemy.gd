extends CharacterBody2D

@export var move_speed = 100
@export var target: Marker2D
@onready var animation_tree: AnimationTree = $AnimationTree

var direction:Vector2=Vector2.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = (target.position - position).normalized()
	velocity = direction * move_speed
	updateAnimation()
	move_and_slide()
func _ready():
	animation_tree.active=true
func updateAnimation():
	animation_tree["parameters/Move/blend_position"] = direction
func _on_hitbox_on_hit(hit_data : HitStats, source):
	queue_free()
