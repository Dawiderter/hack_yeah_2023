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
	
	var dinosaur1_pos = level.generate_point(BiomeType.FOREST)
	var dinosaur2_pos = level.generate_point(BiomeType.FOREST)
	var dinosaur3_pos = level.generate_point(BiomeType.DESERT)
	var dinosaur4_pos = level.generate_point(BiomeType.DESERT)
	

func _process(delta):
	pass

