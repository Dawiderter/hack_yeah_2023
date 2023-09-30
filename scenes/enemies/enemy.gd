extends CharacterBody2D

@export var move_speed = 100
@export var target: Marker2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = (target.position - position).normalized() * move_speed
	move_and_slide()



func _on_hitbox_on_hit(hit_data : HitStats, source):
	queue_free()
