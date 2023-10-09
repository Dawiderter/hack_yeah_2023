extends Node2D

@onready var lifetime : Timer = $lifetime
@onready var sprite : Sprite2D = $Sprite2D

const LIFETIME: float = 2

var scale_speed: float = 5
var move_speed: float = 20
var direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	start_wave(Vector2.DOWN)
	pass # Replace with function body.

func change_damage(new_damage):
	$hurtbox.change_damage(new_damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction != Vector2.ZERO:
		scale += Vector2.ONE * delta * scale_speed
		sprite.modulate.a = lerp(0,1,lifetime.time_left / LIFETIME)
		position += direction * delta * move_speed 

func _on_lifetime_timeout():
	queue_free()

func start_wave(dir: Vector2):
	lifetime.start(LIFETIME)
	direction = dir
	rotation = dir.angle()
