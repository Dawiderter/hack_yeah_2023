extends Control

@export var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	update_expbar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$healthbar.value = player.health
	$expbar.value = player.exp
	update_expbar()

func update_expbar():
	if player.level < player.level_caps.size() - 1:
		$expbar.max_value = player.level_caps[player.level - 1]
