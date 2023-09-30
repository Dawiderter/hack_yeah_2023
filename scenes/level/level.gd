class_name Level

extends TileMap

@onready var rows: int = get_parent().rows
@onready var columns: int = get_parent().columns

const FLOOR_LAYER: int = 0
const FLOOR_TILESET: int = 0
const THRESHOLD = 0.15

var tiles: Array[Vector2i]

func get_noise() -> Noise:
	var noise = FastNoiseLite.new()
	noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)
	return noise

func get_tiles(noise: Noise) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for x in range(rows):
		for y in range(columns):
			tiles.push_back(Vector2i(x, y))
	return tiles
	
func is_valid_resource_tile(coords: Vector2i) -> bool:
	return get_cell_atlas_coords(FLOOR_LAYER, coords) ==  Vector2i(1,1)

func _ready():
	var noise = get_noise()
	
	tiles = get_tiles(noise)
	set_cells_terrain_connect(FLOOR_LAYER, tiles, FLOOR_TILESET, 0)
