extends Node2D

var buttons
var buttons_states = [[false, false, false],[false, false, false],[false, false, false],[false, false, false],[false, false, false]]
var founded_dinos = [true, false, false, false, false]

var empty = load("res://scenes/assets/empty.png")
var gothen = load("res://scenes/assets/gothen.png")
var possible = load("res://scenes/assets/possible.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	buttons = [[$button1x1, $button1x2, $button1x3],[$button2x1, $button2x2, $button2x3],[$button3x1, $button3x2, $button3x3],[$button4x1, $button4x2, $button4x3],[$button5x1, $button5x2, $button5x3]]
	$trex.play("move")
	$tric.play("questionmark")
	$diplo.play("questionmark")
	$steg.play("questionmark")
	$ptero.play("questionmark")
	for y in range(3):
		buttons[0][y].icon = possible

	for x in range(4):
		for y in range(3):
			buttons[x + 1][y].icon = empty

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		for x in range(5):
			for y in range(3):
				if buttons[x][y].is_pressed():
					if founded_dinos[x] && !buttons_states[x][y]:
						buttons_states[x][y] = true
						buttons[x][y].icon = gothen
						get_tree().paused = false

						var dino

						match x:
							0:
								dino = get_parent().get_parent().find_children("trex")
							1:
								dino = get_parent().get_parent().find_children("trice")
							2:
								dino = get_parent().get_parent().find_children("bront")
							3:
								dino = get_parent().get_parent().find_children("stego")
							4:
								dino = get_parent().get_parent().find_children("ptero")

						match y:
							0:
                                dino.speed_times(2)
                            1:
                                dino.damage_times(2)
                            3:
                                dino.range_times(2)

						hide()


func _on_player_levelup():
	show()
	get_tree().paused = true

func get_dino(x):
	founded_dinos[x] = true
	for y in range(3):
		buttons[x][y].icon = possible

func _on_player_bront_s():
	get_dino(2)
	$diplo.play("move")

func _on_player_ptero_s():
	get_dino(4)
	$ptero.play("move")


func _on_player_stego_s():
	get_dino(3)
	$steg.play("move")

func _on_player_trice_s():
	get_dino(1)
	$tric.play("move")

