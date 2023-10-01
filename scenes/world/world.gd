class_name World

extends Node2D

@export var rows: int = 400
@export var columns: int = 400

@onready var level = $Level
@onready var player = $player

func generate_bg():
	var left_up_x = -rows * 16
	var left_up_y = -rows * 16
	var right_up_x = rows * 32
	var right_up_y = -rows * 32
	var right_down_x = rows * 32
	var right_down_y = rows * 32
	var left_down_x = -rows * 32
	var left_down_y = rows * 32
	
	var background: Sprite2D = $Background
	background.resize()

func _ready():
	var player_starting_point = level.generate_starting_position()
	print(player_starting_point)
	player.position = player_starting_point

func _process(delta):
	pass

