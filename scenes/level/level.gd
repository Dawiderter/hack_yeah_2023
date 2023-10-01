class_name Level

extends TileMap

@onready var rows: int = get_parent().rows
@onready var columns: int = get_parent().columns

@export var starting_biome: BiomeType = BiomeType.FOREST
@export var finish_biome: BiomeType = BiomeType.VOLCANO

var biomes: Array[Biome]

enum BiomeType {FOREST, DESERT, VOLCANO}

const FLOOR_LAYER: int = 0
const FLOOR_TILESET: int = 0
const FLOOR_TILESET_ID: int = 0

const FOLIAGE_LAYER: int = 1
const FOLIAGE_TILESET: int = 2
const FOLIAGE_TILESET_ID: int = 3

const NATURE_TILESET: int = 2
const NATURE_TILESET_ID: int = 4
const THRESHOLD = 0.15  

const GRASS_TILESET: int = 3
const GRASS_TILESET_ID: int = 6

const ADDITIONAL_FLOOR_TILESET: int = 4
const ADDITIONAL_FLOOR_TILESET_ID: int = 7

const FOREST_TERRAIN: int = 0
const DESERT_TERRAIN: int = 1
const VOLCANO_TERRAIN: int = 2
const ROCK_TERRAIN: int = 3

const EDGE_WIDTH: int = 20
const jaggedness_coefficient: float = 0.8


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

		var tiles2 = []
		# Generate the inner rectangle where features will be generated
		for x in range(partition.generative_left_top.x, partition.generative_right_bottom.x):
			for y in range(partition.generative_left_top.y, partition.generative_right_bottom.y):
				tiles2.push_back(Vector2i(x, y))
		tile_map.set_cells_terrain_connect(FLOOR_LAYER, tiles2, FLOOR_TILESET, terrain())

		# Generate the left and right jagged edges
		var noise_left = FastNoiseLite.new()
		noise_left.seed = randi()
		var noise_right = FastNoiseLite.new()
		noise_right.seed = randi()
		var left_up_x
		var left_down_x
		var right_up_x
		var right_down_x
		for y in range(partition.generative_left_top.y, partition.generative_right_bottom.y):
			var left_jagged_line = ceil((noise_left.get_noise_1d(y) + 1 ) * (EDGE_WIDTH * jaggedness_coefficient))
			var right_jagged_line = ceil((noise_right.get_noise_1d(y) + 1) * (EDGE_WIDTH * jaggedness_coefficient))
			if y == partition.generative_left_top.y:
				left_up_x = left_jagged_line
				right_up_x = right_jagged_line
			if y == partition.generative_right_bottom.y - 1:
				left_down_x = left_jagged_line
				right_down_x = right_jagged_line
			for k in left_jagged_line:
				var x = partition.generative_left_top.x - k
				tiles.push_back(Vector2i(x, y))
			for k in right_jagged_line:
				var x = partition.generative_right_bottom.x + k
				tiles.push_back(Vector2i(x, y))

		# Generate the upper and lower jagged edges
		var noise_up = FastNoiseLite.new()
		noise_up.seed = randi()
		var noise_down = FastNoiseLite.new()
		noise_down.seed = randi()
		var left_up_y
		var left_down_y
		var right_up_y
		var right_down_y
		for x in range(partition.generative_left_top.x, partition.generative_right_bottom.x):
			var up_jagged_line = ceil((noise_up.get_noise_1d(x) + 1) * (EDGE_WIDTH * jaggedness_coefficient))
			var down_jagged_line = ceil((noise_down.get_noise_1d(x) + 1) * (EDGE_WIDTH * jaggedness_coefficient))
			if x == partition.generative_left_top.x:
				left_up_y = up_jagged_line
				left_down_y = down_jagged_line
			if x == partition.generative_right_bottom.x - 1:
				right_up_y = up_jagged_line
				right_down_y = down_jagged_line
			for k in up_jagged_line:
				var y = partition.generative_left_top.y - k
				tiles.push_back(Vector2i(x, y))
			for k in down_jagged_line:
				var y = partition.generative_right_bottom.y + k
				tiles.push_back(Vector2i(x, y))

		# Fix the left upper corner
		var a = left_up_x
		var b = left_up_y
		var a_sq = a * a
		var b_sq = b * b
		for x in a:
			for y in b:
				var x_t = abs(a) - x
				if (x_t * x_t) / a_sq + (y * y) / b_sq <= 1:
					var x_tt = partition.generative_left_top.x - abs(x_t) + 1
					var y_tt = partition.generative_left_top.y - abs(y)
					tiles.push_back(Vector2i(x_tt, y_tt))

		# Fix the right upper corner
		a = right_up_x
		b = right_up_y
		a_sq = a * a
		b_sq = b * b
		for x in a:
			for y in b:
				if (x * x) / a_sq + (y * y) / b_sq <= 1:
					var x_tt = partition.generative_right_bottom.x + abs(x)
					var y_tt = partition.generative_left_top.y - abs(y)
					tiles.push_back(Vector2i(x_tt, y_tt))

		# Fix the right lower corner
		a = right_down_x
		b = right_down_y
		a_sq = a * a
		b_sq = b * b
		for x in a:
			for y in b:
				var y_t = abs(b) - y
				if (x * x) / a_sq + (y_t * y_t) / b_sq <= 1:
					var x_tt = partition.generative_right_bottom.x + abs(x)
					var y_tt = partition.generative_right_bottom.y + abs(y_t) - 1
					tiles.push_back(Vector2i(x_tt, y_tt))

		# Fix the left lower corner
		a = left_down_x
		b = left_down_y
		a_sq = a * a
		b_sq = b * b
		for x in a:
			for y in b:
				var x_t = abs(a) - x
				var y_t = abs(b) - y
				if (x_t * x_t) / a_sq + (y_t * y_t) / b_sq <= 1:
					var x_tt = partition.generative_left_top.x - abs(x_t)
					var y_tt = partition.generative_right_bottom.y + abs(y_t) - 1
					tiles.push_back(Vector2i(x_tt, y_tt))


		tile_map.set_cells_terrain_connect(FLOOR_LAYER, tiles, 0, terrain())

	func generate_features(tile_map: TileMap):
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
		
	func generate_features(tile_map: TileMap):
		pass

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

		generative_left_top = left_top + length / EDGE_WIDTH
		generative_right_bottom = right_bottom - length / EDGE_WIDTH

	func area() -> int:
		return abs(left_top.x - right_bottom.x) * abs(left_top.y - right_bottom.y)

func get_largest_biome_index(biomes: Array[BiomePartition]) -> int:
	var index = 0
	for i in range(biomes.size()):
		if biomes[i].area() > biomes[index].area():
			index = i
	return index

func is_valid_grass_tile(x: int, y: int) -> bool:
	var cell = get_cell_atlas_coords(FLOOR_LAYER, Vector2i(x, y))
	if cell in [Vector2i(3, 1)]:
		return true
	return false
	
func is_valid_desert_tile(x: int, y: int) -> bool:
	var cell = get_cell_atlas_coords(FLOOR_LAYER, Vector2i(x, y))
	if cell in [Vector2i(3, 4)]:
		return true
	return false

func generate_grass():
	var noise = FastNoiseLite.new()
	noise.frequency = 0.5
	var offset = (EDGE_WIDTH * jaggedness_coefficient)
	for y in range(-offset, rows + offset):
		for x in range(-offset, columns + offset):
			var value = noise.get_noise_2d(x, y)
			if value > THRESHOLD and is_valid_grass_tile(x, y):
				set_cell(FOLIAGE_LAYER, Vector2i(x, y), GRASS_TILESET_ID, Vector2i(0, 0))

func generate_rocks():
	var offset = (EDGE_WIDTH * jaggedness_coefficient * 1.5)
	var tiles = []
	for y in range(-offset, rows + offset):
		for x in range(-offset, columns + offset):
			var cell = get_cell_atlas_coords(FLOOR_LAYER, Vector2i(x, y))
			if cell == Vector2i(-1, -1):
				tiles.push_back(Vector2i(x, y))
				var chance = randf() <= 0.05
				if chance:
					var rock_type = randi_range(0, 2)
					set_cell(FOLIAGE_LAYER, Vector2i(x, y), NATURE_TILESET_ID, Vector2i(17 + rock_type, 17))
				
	set_cells_terrain_connect(FLOOR_LAYER, tiles, 0, 3)

func generate_plants():
	var offset = (EDGE_WIDTH * jaggedness_coefficient)
	for y in range(-offset, rows + offset):
		for x in range(-offset, columns + offset):
			var value = randf()
			if value < 0.005 and is_valid_grass_tile(x, y):
				var x_coord = randi_range(0, 6)
				var y_coord = randi_range(10,11)
				set_cell(FOLIAGE_LAYER, Vector2i(x, y), NATURE_TILESET_ID, Vector2i(x_coord, y_coord))

func generate_twigs():
	var offset = (EDGE_WIDTH * jaggedness_coefficient)
	for y in range(-offset, rows + offset):
		for x in range(-offset, columns + offset):
			var value = randf()
			if value < 0.005 and is_valid_grass_tile(x, y):
				var x_coord = randi_range(12, 13)
				var y_coord = randi_range(11,12)
				set_cell(FOLIAGE_LAYER, Vector2i(x, y), NATURE_TILESET_ID, Vector2i(x_coord, y_coord))

func generate_desert_rocks():
	var offset = (EDGE_WIDTH * jaggedness_coefficient)
	for y in range(-offset, rows + offset):
		for x in range(-offset, columns + offset):
			var value = randf()
			if value < 0.02 and is_valid_desert_tile(x, y):
				var one_size_rocks = [Vector2i(17, 13), Vector2i(18, 13), Vector2i(19, 13)]
				var two_size_rocks = [Vector2i(15, 10), Vector2i(15, 12)]
				var chosen_rock: Vector2i
				if randf() < 0.1 and is_valid_desert_tile(x + 1, y) and is_valid_desert_tile(x + 1, y + 1) and is_valid_desert_tile(x, y + 1):
					chosen_rock = two_size_rocks[randi() % two_size_rocks.size()]
				else:
					chosen_rock = one_size_rocks[randi() % one_size_rocks.size()]
				
				set_cell(FOLIAGE_LAYER, Vector2i(x, y), NATURE_TILESET_ID, chosen_rock)

func partition_map(left_top: Vector2i, right_bottom: Vector2i, count: int) -> Array[BiomePartition]:
	var biomes: Array[BiomePartition] = []
	var len_x = abs(left_top.x - right_bottom.x)
	var len_y = abs(left_top.y - right_bottom.y)
	var x = randi_range(left_top.x + len_x / 4, right_bottom.x - len_x / 4)
	var y = randi_range(left_top.y + len_y / 4, right_bottom.y - len_y / 4)
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

func generate_starting_position():
	var tile_size = tile_set.tile_size
	var biome = find_biome(biomes, starting_biome)
	var left_top = biome.partition.generative_left_top
	var right_bottom = biome.partition.generative_right_bottom
	var x = randi_range(left_top.x * tile_size.x, right_bottom.x * tile_size.x)
	var y = randi_range(left_top.y * tile_size.y, right_bottom.y * tile_size.y)
	return Vector2i(x, y)

func generate_time_machine():
	var tile_size = tile_set.tile_size
	var biome = find_biome(biomes, finish_biome)
	var left_top = biome.partition.generative_left_top
	var right_bottom = biome.partition.generative_right_bottom
	var x = randi_range(left_top.x * tile_size.x, right_bottom.x * tile_size.x)
	var y = randi_range(left_top.y * tile_size.y, right_bottom.y * tile_size.y)
	return Vector2i(x, y)

func _ready():
	var biome_count = 3
	var biome_partitions = partition_map(Vector2i(0,0), Vector2i(rows - 1, columns - 1), biome_count)

	biomes = create_biomes(biome_partitions)

	for biome in biomes:
		biome.generate_floor(self)
		
	generate_grass()
	generate_twigs()
	
	generate_rocks()
	
	generate_desert_rocks()
