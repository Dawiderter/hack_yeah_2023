class_name Level

extends TileMap

@onready var rows: int = get_parent().rows
@onready var columns: int = get_parent().columns

const FLOOR_LAYER: int = 0
const FLOOR_TILESET: int = 0
const FLOOR_TILESET_ID: int = 2
const FOLIAGE_LAYER: int = 1
const FOLIAGE_TILESET: int = 3
const THRESHOLD = 0.15                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            

func get_noise() -> Noise:
	var noise = FastNoiseLite.new()
	noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)
	return noise

	
func is_valid_resource_tile(coords: Vector2i) -> bool:
	return get_cell_atlas_coords(FLOOR_LAYER, coords) ==  Vector2i(1,1)

enum biome_type{FOREST, VOLCANO, DESERT, ACID_LAKES}

class Biome:
	var left_top: Vector2i
	var right_bottom: Vector2i
		
	func _init(x1, y1, x2, y2):
		left_top = Vector2i(x1, y1)
		right_bottom = Vector2i(x2, y2)
		
	func area() -> int:
		return abs(left_top.x - right_bottom.x) * abs(left_top.y - right_bottom.y)
	
	func fill(tile_map: TileMap, tile_coords: Vector2i):
		for x in range(left_top.x, right_bottom.x):
			for y in range(left_top.y, right_bottom.y):
				tile_map.set_cell(FLOOR_LAYER, Vector2i(x, y), FLOOR_TILESET_ID, tile_coords)
		
func get_largest_biome_index(biomes: Array[Biome]) -> int:
	var index = 0
	for i in range(biomes.size()):
		if biomes[i].area() > biomes[index].area():
			index = i
	return index

func partition_map(left_top: Vector2i, right_bottom: Vector2i, count: int) -> Array[Biome]:
	var biomes: Array[Biome] = []
	var x = randi_range(left_top.x, right_bottom.x)
	var y = randi_range(left_top.y, right_bottom.y)
	biomes.push_back(Biome.new(left_top.x, left_top.y, x, y))
	biomes.push_back(Biome.new(x, left_top.y, right_bottom.x, y))
	biomes.push_back(Biome.new(x, y, right_bottom.x, right_bottom.y))
	biomes.push_back(Biome.new(left_top.x, y, x, right_bottom.y))
	if count > 4:
		var largest_biome_index = get_largest_biome_index(biomes)
		var largest_biome = biomes[largest_biome_index]
		biomes.remove_at(largest_biome_index)
		var partitioned = partition_map(largest_biome.left_top, largest_biome.right_bottom, count - 3)
	
	return biomes
	
func get_tiles(noise: Noise) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for x in range(rows):
		for y in range(columns):
			tiles.push_back(Vector2i(x, y))
	return tiles

func _ready():
	var biome_count = 4
	var biomes = partition_map(Vector2i(0,0), Vector2i(rows - 1, columns - 1), biome_count)
	for i in range(4):
		print(i, biomes[i].left_top, biomes[i].right_bottom)
	biomes[0].fill(self, Vector2i(0,0))
	biomes[1].fill(self, Vector2i(1,0))
	biomes[2].fill(self, Vector2i(2,0))
	biomes[3].fill(self, Vector2i(3,0))
	#var biomes_list: Array[biome_type]
	
	#set_cell(FLOOR_LAYER, Vector2i(0, 0), 2, Vector2i(0,0))
	#var noise = get_noise()
	
	#var tiles = get_tiles(noise)
	#set_cells_terrain_connect(FLOOR_LAYER, tiles, FLOOR_TILESET, 0)

