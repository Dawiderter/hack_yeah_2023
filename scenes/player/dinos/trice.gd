extends CharacterBody2D

@export var range_radius: float
@export var chasing_speed: float
@export var returning_speed: float
@export var player_keep_range: float
@export var player_target: CharacterBody2D

@onready var range_area: Area2D = $range
@onready var range_shape: CollisionShape2D = $range/CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum { SEARCHING, CHASING, RETURNING }
var enemy_target: Node2D

var trice_state = RETURNING

func _ready():
	set_range_radius(range_radius)

func _physics_process(delta):
	velocity = Vector2.ZERO

	match trice_state:
		SEARCHING:
			var enemies = range_area.get_overlapping_bodies()
			if !enemies.is_empty():
				var closest = closest_enemy(enemies)
				enemy_target = enemies[closest]
				trice_state = CHASING
			elif player_target:
				if !player_target.velocity.is_zero_approx():
					var target_point = player_target.position + -player_target.velocity.normalized() * player_keep_range / 2
					velocity = (target_point - position) / (20 * delta)
		CHASING:
			if !is_instance_valid(enemy_target) or enemy_target.is_queued_for_deletion():
				trice_state = RETURNING
				enemy_target = null
			else:
				var dir = position.direction_to(enemy_target.position)
				velocity = (dir * chasing_speed)/2
		RETURNING:
			if player_target and player_target.position.distance_to(position) >= player_keep_range:
				var dir = position.direction_to(player_target.position)
				velocity = (dir * returning_speed)
			else:
				trice_state = SEARCHING

	if velocity.is_zero_approx():
		sprite.play("default")
	else:
		sprite.play("move")
		if velocity.x > 0:
			sprite.flip_h = true
		elif velocity.x < 0:
			sprite.flip_h = false

	move_and_slide()

func closest_enemy(enemies: Array[Node2D]) -> int:
	var min_dist = enemies[0].position.distance_squared_to(position)
	var min_i = 0
	for i in range(enemies.size()):
		var dist = enemies[i].position.distance_squared_to(position)
		if dist < min_dist:
			min_i = i
			min_dist = dist
	
	return min_i

func set_range_radius(_radius):
	range_radius = _radius
	range_shape.shape.radius = range_radius


func _on_hurtbox_area_entered(area):
	$ChargeHit.play()
