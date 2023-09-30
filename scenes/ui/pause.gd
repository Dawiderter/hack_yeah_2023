extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pause_button_pressed():
	get_tree().paused = true
	$pause_popup.show()
	
func _on_pause_popup_close_pressed():
	$pause_popup.hide()
	get_tree().paused = false
