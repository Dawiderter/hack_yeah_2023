extends Label


@onready var timer = $FinalTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	print(timer)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = String.num(timer.time_left, 0) + " s"
	pass
