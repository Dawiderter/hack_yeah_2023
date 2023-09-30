extends AnimationPlayer

@export var skip_speed = 100
var progress_bar
# Called when the node enters the scene tree for the first time.
func _ready():
	play("history")
	progress_bar = get_node("circular_progressbar/TextureProgressBar")
	progress_bar.value = 0

func _process(delta):
	if Input.is_action_pressed("skip"):
		print("Hi")
		progress_bar.value += skip_speed * delta
		if progress_bar.value >= 100:
			get_tree().change_scene_to_file("res://scenes/player/player_test.tscn") 
	else:
		progress_bar.value -= skip_speed * delta
		if progress_bar.value < 0:
			progress_bar.value = 0


func _on_end_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/player/player_test.tscn")
