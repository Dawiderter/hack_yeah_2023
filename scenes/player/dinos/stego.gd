extends Node2D

@export var player_keep_range: float
@export var range_radius: float

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_anim: AnimatedSprite2D = $hurt_anim
@onready var shape: CollisionShape2D = $hurtbox/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_range_radius(range_radius)
	hurt_anim.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false

	if direction.is_zero_approx():
		sprite.play("default")
	else:
		position = position.lerp(-direction * player_keep_range, 0.01)
		sprite.play("move")

func set_range_radius(_range_radius: float):
	range_radius = _range_radius
	shape.shape.radius = range_radius
	hurt_anim.scale.x = range_radius / 40
	hurt_anim.scale.y = range_radius / 40
