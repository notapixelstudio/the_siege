extends Node

signal attack_done
signal spawn_done
signal move_done

var tile_size

var grid_size = Vector2(33, 25)
var grid = []
var map
var tiledict

var Pawn
var pawns = []

var spawn_points = [[], [], [], []] # NSWE

var step = 0 # TO BE REMOVED

enum ENTITY_TYPES {PAWN}

func _ready():
	# set up a new random seed
	# FIXME this should be done at game level
	randomize()
	
	map = get_node("GridMap/base")
	tiledict = map.get_tileset().get_meta('tile_meta')
	tile_size = map.get_cell_size()
	
	# Create the grid Array
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
			
	# Load spawn points from tilemap
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var tile_id = get_node("GridMap/spawn").get_cell(x, y)
			if tile_id == 55:
				spawn_points[1].append(Vector2(x,y))
			elif tile_id == 56:
				spawn_points[2].append(Vector2(x,y))
			elif tile_id == 57:
				spawn_points[0].append(Vector2(x,y))
			elif tile_id == 58:
				spawn_points[3].append(Vector2(x,y))
				
	Pawn = load('res://Pawn.tscn')
	
func _input(event):
	if event.is_action_pressed('ui_select') and not event.is_echo():
		print(step)
		if step == 0:
			pawns_attack()
		elif step == 1:
			spawn_pawns()
		elif step == 2:
			move_pawns()
			
		step = (step + 1) % 3
	
# the object will ask if the cell is vacant
func is_cell_vacant(pos, direction):
	# Return true if the cell is vacant, else false

	var grid_pos = map.world_to_map(pos) + direction
	var tile_id = map.get_cellv(grid_pos)
	var solid = tile_id in tiledict and tiledict[tile_id]["solid"]
	
	# world boundaries
	if grid_pos.x < grid_size.x and grid_pos.x >=0:
		if grid_pos.y < grid_size.y and grid_pos.y >=0:
			return grid[grid_pos.x][grid_pos.y] == null and not solid
			
	return false
	
func break_cell(pos, direction):
	var grid_pos = map.world_to_map(pos) + direction
	var tile_id = map.get_cellv(grid_pos)
	var breakable = tile_id in tiledict and tiledict[tile_id]["breakable"]
	
	if breakable:
		map.set_cellv(grid_pos, 38) # ground tile
	
func update_child_pos(child_node):
	# Move a child to a new position in the grid Array
	# Returns the new target world position of the child
	var grid_pos = map.world_to_map(child_node.position)
	grid[grid_pos.x][grid_pos.y] = null
	
	var new_grid_pos = grid_pos + child_node.direction
	grid[new_grid_pos.x][new_grid_pos.y] = child_node.type
	
	var target_pos = map.map_to_world(new_grid_pos) + tile_size/2
	return target_pos

func spawn_pawn(pos, direction):
	var pawn = Pawn.instance()
	pawns.append(pawn)
	pawn.position = map.map_to_world(pos) + tile_size/2 # bleargh
	pawn.facing = direction
	var start_pos = update_child_pos(pawn)
	pawn.position = start_pos
	add_child(pawn)
	
func spawn_pawns():
	# choose a random direction
	var random_dir_index = randi() % 4
	var direction = [Vector2(0,1),Vector2(0,-1),Vector2(1,0),Vector2(-1,0)][random_dir_index]
	var active_spawn_points = spawn_points[random_dir_index]
	
	# spawn one pawn from each spawn point, directed towards the center
	for spawn_point in active_spawn_points:
		spawn_pawn(spawn_point, direction)
	
func move_pawns():
	for pawn in pawns:
		pawn.march()
		
func pawns_attack():
	for pawn in pawns:
		pawn.break_walls()
		