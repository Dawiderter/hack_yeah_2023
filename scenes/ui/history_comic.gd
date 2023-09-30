extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	play("history")

func _on_end_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/player/player_test.tscn")
