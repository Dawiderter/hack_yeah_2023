class_name World

extends Node2D

@export var rows: int = 400
@export var columns: int = 400

@onready var level = $Level
@onready var player = $player

func _ready():
	var player_starting_point = level.generate_starting_position()
	print(player_starting_point)
	player.position = player_starting_point

func _process(delta):
	pass

