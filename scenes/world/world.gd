class_name World

extends Node2D

@export var rows: int = 400
@export var columns: int = 400

@onready var level = $Level
@onready var player = $player
@onready var portal = $Portal

func _ready():
	var player_starting_point = level.generate_starting_position()
	player.position = player_starting_point
	
	var finish_point = level.generate_time_machine()
	portal.position = finish_point

func _process(delta):
	pass

