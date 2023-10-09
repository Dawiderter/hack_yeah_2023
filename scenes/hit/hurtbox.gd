class_name Hurtbox

extends Area2D

@export var hit_data: HitStats

@onready var timer: Timer = $intensity

func change_damage(new_damage):
	hit_data.damage_dealt = new_damage

# Called when the node enters the scene tree for the first time.
func _ready():
	if hit_data.intensity_seconds != 0:
		timer.wait_time = hit_data.intensity_seconds
		timer.start()

func _on_intensity_timeout():
	if hit_data.intensity_seconds != 0:
		deal_damage_to_all()

func deal_damage_to_all():
	for area in get_overlapping_areas():
		if area.name == "hitbox":
			area.get_hit(hit_data, self)

func _on_area_entered(area:Area2D):
	if hit_data.damage_on_enter:
		if area.name == "hitbox":
			area.get_hit(hit_data, self)
			if hit_data.destroy_on_hit:
				queue_free()
