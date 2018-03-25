extends Node2D

var state = 'idle'
var busy_pawns = 0

signal attack_done
signal spawn_done
signal move_done

var tile_size

var grid_size = Vector2(33, 25)
var grid = []
var map
var buildings_map
var tiledict

var Pawn
var pawns = []

var spawn_points = [[], [], [], []] # NSWE

# health of buildings
var castle_health = 6
const CASTLE_SEVERE_HITPOINTS = 2
var wizard_building_health = 3
var commander_building_health = 3
var carpenter_building_health = 3

# cursor
var cursor_shape = [Vector2(0,-1),Vector2(0,0),Vector2(0,1)]
var last_cursor_pos = Vector2(0,0)
var cursor_map

# card action
var chosen_card

var game_node
var ui_node

func _ready():
	# set up a new random seed
	# FIXME this should be done at game level
	randomize()
	
	game_node = get_node("/root/Game")
	ui_node = get_node("/root/Game/UI")
	map = get_node("GridMap/base")
	buildings_map = get_node("GridMap/buildings")
	cursor_map = get_node("GridMap/cursor")
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
			if tile_id == 74:
				spawn_points[1].append(Vector2(x,y))
			elif tile_id == 75:
				spawn_points[2].append(Vector2(x,y))
			elif tile_id == 76:
				spawn_points[0].append(Vector2(x,y))
			elif tile_id == 77:
				spawn_points[3].append(Vector2(x,y))
				
	Pawn = load('res://Pawn.tscn')
	
# the object will ask if the cell is vacant
func is_cell_vacant(pos, direction):
	# Return true if the cell is vacant, else false

	var grid_pos = map.world_to_map(pos) + direction
	var tile_id = map.get_cellv(grid_pos)
	var buildings_tile_id = buildings_map.get_cellv(grid_pos)
	var solid = tile_id in tiledict and tiledict[tile_id]["solid"] or buildings_tile_id in tiledict and tiledict[buildings_tile_id]["solid"]
	
	# world boundaries
	if grid_pos.x < grid_size.x and grid_pos.x >=0:
		if grid_pos.y < grid_size.y and grid_pos.y >=0:
			return grid[grid_pos.x][grid_pos.y] == null and not solid
			
	return false
	
func break_cell(pos, direction):
	var grid_pos = map.world_to_map(pos) + direction
	damage_building(grid_pos)

func update_child_pos(child_node):
	# Move a child to a new position in the grid Array
	# Returns the new target world position of the child
	var grid_pos = map.world_to_map(child_node.position)
	grid[grid_pos.x][grid_pos.y] = null
	
	var new_grid_pos = grid_pos + child_node.direction
	grid[new_grid_pos.x][new_grid_pos.y] = child_node
	
	var target_pos = map.map_to_world(new_grid_pos) + tile_size/2
	return target_pos
	
func do_spawn():
	state = 'spawn'
	
	# choose a random direction
	var random_dir_index = randi() % 4
	var direction = [Vector2(0,1),Vector2(0,-1),Vector2(1,0),Vector2(-1,0)][random_dir_index]
	var active_spawn_points = spawn_points[random_dir_index]
	
	# spawn one pawn from each spawn point, directed towards the center
	for spawn_point in active_spawn_points:
		spawn_pawn(spawn_point, direction)
		
	busy_pawns = len(active_spawn_points)
	
func do_move():
	state = 'move'
	busy_pawns = len(pawns)
	
	for pawn in pawns:
		pawn.march()
		
func do_attack():
	state = 'attack'
	busy_pawns = len(pawns)
	
	for pawn in pawns:
		pawn.attack()
		
func _process(delta):
	if busy_pawns == 0:
		if state == 'spawn':
			print('spawn_done')
			state = 'idle'
			emit_signal('spawn_done')
		elif state == 'attack':
			print('attack_done')
			state = 'idle'
			emit_signal('attack_done')
		elif state == 'move':
			print('move_done')
			state = 'idle'
			emit_signal('move_done')

func _input(event):
	if game_node.game_state == game_node.P_EXEC_C1 or game_node.game_state == game_node.P_EXEC_C2 :
		if event is InputEventMouseMotion:
			var pos = Vector2(round((event.global_position.x - position.x - tile_size.x/2)/tile_size.x), round((event.global_position.y - position.y - tile_size.y/2)/tile_size.y))
			if pos != last_cursor_pos:
				for cell in cursor_shape:
					cursor_map.set_cellv(cell + last_cursor_pos, -1)
				last_cursor_pos = pos
				for cell in cursor_shape:
					var cursor_tile = cell + pos
					if is_within_the_grid(cursor_tile):
						cursor_map.set_cellv(cursor_tile, 78)
		if event is InputEventMouseButton:
			chosen_card.resolve(get_node("/root/Game/Battlefield"), last_cursor_pos)
			for cell in cursor_shape:
					cursor_map.set_cellv(cell + last_cursor_pos, -1)
			if game_node.game_state == game_node.P_EXEC_C2:
				game_node.player_end_turn()
			else:
				game_node.game_state=game_node.P_EXEC_C1_COMPLETED
			
		
func set_cursor_shape(card):
	cursor_shape = card.get_shape()
	chosen_card = card
	
# ---
# board-altering methods
# ---

func is_within_the_grid(pos):
	return pos.x >= 0 and pos.x < grid_size.x and pos.y >= 0 and pos.y < grid_size.y
	
func raise_wall(pos):
	if not is_within_the_grid(pos):
		return
		
	if grid[pos.x][pos.y] != null:
		return

	buildings_map.set_cellv(pos, 17) # single tile wall

func damage_building(pos):
	var tile_id = buildings_map.get_cellv(pos)
	var breakable = tile_id in tiledict and tiledict[tile_id]["breakable"]

	if breakable:
		destroy_building(pos)
	elif tile_id in [5,6,7,25,26,27,45,46,47]: # castle
		castle_health -= 1
		if castle_health == CASTLE_SEVERE_HITPOINTS:
			game_node.on_castle_severely_hit()
		elif castle_health <= 0:
			for x in [15,16,17]:
				for y in [12,13,14]:
					destroy_building(Vector2(x,y))
			game_node.on_castle_destroyed()
	elif tile_id in [8,9,28,29]: # carpenter's building
		carpenter_building_health -= 1
		if carpenter_building_health <= 0:
			for x in [12,13]:
				for y in [14,15]:
					destroy_building(Vector2(x,y))
			game_node.on_building_destroyed(game_node.enum_counselor.CARPENTER)
	elif tile_id in [10,11,30,31]: # commander's building
		commander_building_health -= 1
		if commander_building_health <= 0:
			for x in [19,20]:
				for y in [11,12]:
					destroy_building(Vector2(x,y))
			game_node.on_building_destroyed(game_node.enum_counselor.COMMANDER)
	elif tile_id in [12,13,32,33]: # wizard's building
		wizard_building_health -= 1
		if wizard_building_health <= 0:
			for x in [14,15]:
				for y in [9,10]:
					destroy_building(Vector2(x,y))
			game_node.on_building_destroyed(game_node.enum_counselor.WIZARD)

func destroy_building(pos):
	if not is_within_the_grid(pos):
		return
		
	buildings_map.set_cellv(pos, -1)

func spawn_pawn(pos, direction):
	if not is_within_the_grid(pos):
		return
		
	var pawn = Pawn.instance()
	pawns.append(pawn)
	pawn.position = map.map_to_world(pos) + tile_size/2 # bleargh
	pawn.facing = direction
	var start_pos = update_child_pos(pawn)
	pawn.position = start_pos
	add_child(pawn)
	
	return pawn

func kill_pawn(pos):
	if not is_within_the_grid(pos):
		return
		
	var pawn = grid[pos.x][pos.y]
	if pawn != null:
		var i = 0
		for p in pawns:
			if p == pawn:
				break
			i += 1
			
		pawns.remove(i)
		pawn.queue_free()
		grid[pos.x][pos.y] = null
		
func fire_damage(pos):
	kill_pawn(pos)
	damage_building(pos)
