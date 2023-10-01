extends Area2D

func get_hit(hit_data: HitStats, source: Area2D):
	emit_signal("on_hit", hit_data, source)

signal on_hit(hit_data: HitStats, source: Area2D)
