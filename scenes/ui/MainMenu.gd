extends Control

@export var camera_speed = 2
@export var camera_distance = 10
var center
# Called when the node enters the scene tree for the first time.
func _ready():
	var size = $TextureRect.get_size() 
	center = size * 0.5 
	$TextureRect.set_size(Vector2(size.x + 2* camera_distance, size.y + 2* camera_distance))
	$TextureRect.set_position(Vector2(-camera_distance, -camera_distance))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = (get_viewport().get_mouse_position() - center ).normalized()

	var camera_position = direction * camera_distance
	camera_position += Vector2(-camera_distance, -camera_distance)
	$TextureRect.position += (camera_position - $TextureRect.position) * camera_speed * delta


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")

	get_tree().change_scene_to_file("res://scenes/ui/history_comic.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()
	

