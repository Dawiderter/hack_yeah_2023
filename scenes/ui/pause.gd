extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	hide()

func _process(delta):
	pass

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		show()

func _on_Enter_button_down():
	get_tree().paused = false
	hide()


func _on_continue_pressed():
	get_tree().paused = false
	hide()


func _on_restart_pressed():
	get_tree().paused = false
	hide()
	get_tree().change_scene_to_file("res://scenes/player/player.tscn")


func _on_exit_pressed():
	get_tree().quit()
