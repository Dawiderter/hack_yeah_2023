extends Node2D

@export var speed: float = 50
@export var duration: float = 5
var direction : Vector2 = Vector2.ZERO

@onready var timer: Timer = $lifetime

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(duration)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta

func _on_lifetime_timeout():
	queue_free()


func _on_hitbox_on_hit(hit_data, source):
	queue_free()
