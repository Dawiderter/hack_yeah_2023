class_name World

extends Node2D

@export var rows: int = 400
@export var columns: int = 400

@onready var level = $Level
@onready var player = $player
@onready var portal = $Portal

func _ready():
	var player_starting_point = level.generate_point(level.starting_biome)
	player.position = player_starting_point
	
	var finish_point = level.generate_point(level.finish_biome)
	portal.position = finish_point
	
	level.generate_dinosaurs()

func _process(delta):
	pass

