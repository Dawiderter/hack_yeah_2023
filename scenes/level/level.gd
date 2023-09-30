class_name Level

extends TileMap

@onready var rows: int = get_parent().rows
@onready var columns: int = get_parent().columns

enum BiomeType {FOREST, DESERT, VOLCANO}

const FLOOR_LAYER: int = 0
const FLOOR_TILESET: int = 0
const FLOOR_TILESET_ID: int = 2
const FOLIAGE_LAYER: int = 1
const FOLIAGE_TILESET: int = 3
const THRESHOLD = 0.15  

const FOREST_TERRAIN: int = 0
const DESERT_TERRAIN: int = 1
const VOLCANO_TERRAIN: int = 2


func get_noise() -> Noise:
	var noise = FastNoiseLite.new()
	noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)
	return noise

func is_valid_resource_tile(coords: Vector2i) -> bool:
	return get_cell_atlas_coords(FLOOR_LAYER, coords) ==  Vector2i(1,1)

enum biome_type{FOREST, VOLCANO, DESERT, ACID_LAKES}

class Biome:
	var partition: BiomePartition

	func _init(partition):
		self.partition = partition
		
	func terrain():
		pass

	func type():
		pass

	func generate_floor(tile_map: TileMap):
		var tiles = []
		for x in range(partition.generative_left_top.x, partition.generative_right_bottom.x):
			for y in range(partition.generative_left_top.y, partition.generative_right_bottom.y):
				tiles.push_back(Vector2i(x, y))
		var noise_left = FastNoiseLite.new()
		var noise_right = FastNoiseLite.new()
		for y in range(partition.generative_left_top.y, partition.generative_right_bottom.y):
			var left_jagged_line = ceil((noise_left.get_noise_1d(y) + 1 ) * 10)
			for k in left_jagged_line:
				var x = partition.generative_left_top.x- k
				tiles.push_back(Vector2i(x, y))
			var right_jagged_line = ceil((noise_right.get_noise_1d(y) + 1) * 10)
			for k in right_jagged_line:
				var x = partition.generative_right_bottom.x + k
				tiles.push_back(Vector2i(x, y))
		var noise_up = FastNoiseLite.new()
		var noise_down = FastNoiseLite.new()
		for x in range(partition.generative_left_top.x, partition.generative_right_bottom.x):
			var up_jagged_line = ceil((noise_up.get_noise_1d(x) + 1) * 10)
			for k in up_jagged_line:
				var y = partition.generative_left_top.y - k
				tiles.push_back(Vector2i(x, y))
			var down_jagged_line = ceil((noise_down.get_noise_1d(x) + 1) * 10)
			for k in down_jagged_line:
				var y = partition.generative_right_bottom.y + k
				tiles.push_back(Vector2i(x, y))

		tile_map.set_cells_terrain_connect(FLOOR_LAYER, tiles, FLOOR_TILESET, terrain())
	
	func generate_features():
		pass

class DesertBiome extends Biome:
	func type():
		return BiomeType.DESERT
		
	func terrain():
		return DESERT_TERRAIN

class ForestBiome extends Biome:
	func type():
		return BiomeType.FOREST
		
	func terrain():
		return FOREST_TERRAIN

class VolcanoBiome extends Biome:
	func type():
		return BiomeType.VOLCANO
		
	func terrain():
		return VOLCANO_TERRAIN

class BiomePartition:
	var left_top: Vector2i
	var right_bottom: Vector2i
	
	var generative_left_top: Vector2i
	var generative_right_bottom: Vector2i
		
	func _init(x1, y1, x2, y2):
		left_top = Vector2i(x1, y1)
		right_bottom = Vector2i(x2, y2)
		
		var length = Vector2i(abs(left_top.x - right_bottom.x), abs(left_top.y - right_bottom.y))
		
		generative_left_top = left_top + length / 20
		generative_right_bottom = right_bottom - length / 20
		
	func area() -> int:
		return abs(left_top.x - right_bottom.x) * abs(left_top.y - right_bottom.y)
	
func get_largest_biome_index(biomes: Array[BiomePartition]) -> int:
	var index = 0
	for i in range(biomes.size()):
		if biomes[i].area() > biomes[index].area():
			index = i
	return index

func partition_map(left_top: Vector2i, right_bottom: Vector2i, count: int) -> Array[BiomePartition]:
	var biomes: Array[BiomePartition] = []
	var x = randi_range(left_top.x, right_bottom.x)
	var y = randi_range(left_top.y, right_bottom.y)
	if count == 1:
		biomes.push_back(BiomePartition.new(left_top.x, left_top.y, right_bottom.x, right_bottom.y))
	elif count == 2:
		biomes.push_back(BiomePartition.new(left_top.x, left_top.y, x, right_bottom.y))
		biomes.push_back(BiomePartition.new(x, left_top.y, right_bottom.x, right_bottom.y))
	elif count == 3:
		biomes.push_back(BiomePartition.new(left_top.x, left_top.y, x, y))
		biomes.push_back(BiomePartition.new(x, left_top.y, right_bottom.x, y))
		biomes.push_back(BiomePartition.new(left_top.x, y, right_bottom.x, right_bottom.y))
	else:
		biomes.push_back(BiomePartition.new(left_top.x, left_top.y, x, y))
		biomes.push_back(BiomePartition.new(x, left_top.y, right_bottom.x, y))
		biomes.push_back(BiomePartition.new(x, y, right_bottom.x, right_bottom.y))
		biomes.push_back(BiomePartition.new(left_top.x, y, x, right_bottom.y))
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
	
func find_biome(biomes: Array[Biome], type: BiomeType) -> Biome:
	for biome in biomes:
		if biome.type() == type:
			return biome
	return null

func create_biomes(partitions: Array[BiomePartition]) -> Array[Biome]:
	var biomes: Array[Biome] = []
	
	randomize()
	var biome_types = BiomeType.values()
	biome_types.shuffle()
	
	for i in range(biome_types.size()):
		var type = biome_types[i]
		var partition = partitions[i]
		var biome: Biome
		match type:
			BiomeType.FOREST:
				biome = ForestBiome.new(partition)
			BiomeType.DESERT:
				biome = DesertBiome.new(partition)
			BiomeType.VOLCANO:
				biome = VolcanoBiome.new(partition)
		biomes.push_back(biome)
	
	return biomes

func generate_starting_position(biome: Biome):
	pass

func generate_time_machine(biome: Biome):
	pass

func _ready():
	var biome_count = 3
	var biome_partitions = partition_map(Vector2i(0,0), Vector2i(rows - 1, columns - 1), biome_count)

	var biomes: Array[Biome] = create_biomes(biome_partitions)

	var starting_biome = find_biome(biomes, BiomeType.FOREST)
	generate_starting_position(starting_biome)
	var finishing_biome = find_biome(biomes, BiomeType.VOLCANO)
	generate_time_machine(finishing_biome)

	for biome in biomes:
		biome.generate_floor(self)
