extends Area2D

@export var invincibility_seconds: float = 1

@onready var iframes : Timer = $iframes

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if iframes.is_stopped():
		for area in get_overlapping_areas():
			if area.name == "hurtbox":
				iframes.wait_time = invincibility_seconds
				iframes.start()
				emit_signal("on_hit", area.hit_data, area)

signal on_hit(hit_data: HitStats, source: Area2D)
