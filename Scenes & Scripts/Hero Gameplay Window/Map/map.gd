extends Node2D
class_name DungeonMap

@export var map_pieces : Array[PackedScene] = []

var empty_tilemap
var astar := AStar2D.new()
var previous_exit_cell : Vector2i = Vector2i.ZERO

@export var debug_show_marker_cells : bool = false
@export var font: SystemFont  # Assign a DynamicFont resource for text drawing

#	Terms:
#	Cell - An isometric square of the tile map
#		They are represented by a vector2i i.e. Vector2i(0, 1) 
#	ID - Arbitrary id number for astar to differentiate points


func initialize(): # Called from Level Builder's _ready()
	empty_tilemap = $TileMapLayer

func spawn_random_map_piece() -> TileMapLayer:
	var instance
	var random_index = randi() % map_pieces.size()
	if random_index >= 0 and random_index < map_pieces.size():
		var piece_scene = map_pieces[random_index]
		instance = piece_scene.instantiate() as TileMapLayer
		if previous_exit_cell != Vector2i.ZERO: # If a previous exit cell exists
			var exit_world_position = cell_to_world(previous_exit_cell)  # Convert exit cell to world position
			instance.position = exit_world_position  # Position the new piece at the previous exit
		empty_tilemap.add_child(instance)
		add_and_link_astar(instance)
#		print("Spawned level piece at position: ", instance.position)
#	else:
#		print("Invalid piece index: ", random_index)
		
	return instance

#		------------ Important public functions ------------ 

func cell_to_world(tile_coords: Vector2i) -> Vector2:
	var local_pos = empty_tilemap.map_to_local(tile_coords) # Convert tile to local position
	return empty_tilemap.to_global(local_pos)  # Convert local position to world space

func world_to_cell(world_position: Vector2) -> Vector2i:
#	tilemap_layer
	var local_position = empty_tilemap.to_local(world_position) # Convert world to local space
	return empty_tilemap.local_to_map(local_position)  # Convert local position to map (tile) coordinates

func tile_to_local(tile_coords: Vector2i) -> Vector2:
	return empty_tilemap.map_to_local(tile_coords)  # Converts tile coordinates to local position

func get_enemy_spawn_positions(tilemaplayer : TileMapLayer) -> Array[Vector2] :
	var enemy_spawners : Array[Vector2] = []
	var marker_tilemap : TileMapLayer = tilemaplayer.get_child(0)
	var marker_cells = marker_tilemap.get_used_cells() # Get marker cells such as exit, spawn_enemies, etc.
	for cell in marker_cells:
		var is_spawner = marker_tilemap.get_cell_tile_data(cell).get_custom_data("enemy_spawner")
		if is_spawner:
			var cell_global_position = cell_to_world(cell) + tilemaplayer.global_position
			print("cell: ", cell ,"spawner cell to world: ", cell_to_world(cell))
			enemy_spawners.append(cell_global_position)
	print(enemy_spawners)
	return enemy_spawners

func remove_from_astar(tilemaplayer : TileMapLayer):
	if tilemaplayer:
		var level_cells = tilemaplayer.get_used_cells()  # Get all cells in this layer
		var marker_tilemap : TileMapLayer = tilemaplayer.get_child(0)
		var marker_cells = marker_tilemap.get_used_cells() # Get marker cells such as exit, spawn_enemies, etc.
		
		var layer_offset = world_to_cell(tilemaplayer.position) + Vector2i(0, 1)  # Calculate the offset in cell coordinates
		
		for cell in level_cells:
			var adjusted_cell = cell + layer_offset  # Adjust cell coordinates with the offset
			var cell_index = _cell_to_id(adjusted_cell)  # Generate a unique index for this cell
			# Add the cell to AStar2D
			astar.remove_point(cell_index)
			# Disable the point if it's not walkable
		_link_neighbors()

func add_and_link_astar(tilemaplayer : TileMapLayer):
	if tilemaplayer:
		var level_cells = tilemaplayer.get_used_cells()  # Get all cells in this layer
		var marker_tilemap : TileMapLayer = tilemaplayer.get_child(0)
		var marker_cells = marker_tilemap.get_used_cells() # Get marker cells such as exit, spawn_enemies, etc.
		
		var layer_offset = world_to_cell(tilemaplayer.position) + Vector2i(0, 1)  # Calculate the offset in cell coordinates
		
		for cell in level_cells:
			var walkable = tilemaplayer.get_cell_tile_data(cell).get_custom_data("walkable")
			var local_pos = tilemaplayer.map_to_local(cell)
			var world_pos = tilemaplayer.to_global(local_pos)  # Convert to global space
			var adjusted_cell = cell + layer_offset  # Adjust cell coordinates with the offset
			var cell_index = _cell_to_id(adjusted_cell)  # Generate a unique index for this cell
			# Add the cell to AStar2D
			astar.add_point(cell_index, world_pos)
			# Disable the point if it's not walkable
			if not walkable:
				astar.set_point_disabled(cell_index, true)
		
		for cell in marker_cells:
			var adjusted_cell = cell + layer_offset
			var is_exit = marker_tilemap.get_cell_tile_data(cell).get_custom_data("exit")
			var cell_index = _cell_to_id(adjusted_cell)
			var world_pos = tilemaplayer.to_global(marker_tilemap.map_to_local(cell))
			astar.add_point(cell_index, world_pos)
			if is_exit:
				previous_exit_cell = cell + layer_offset
				_add_exit_collider(world_pos, tilemaplayer)
			pass
		
		if debug_show_marker_cells == false : marker_tilemap.visible = false
		
		_link_neighbors()
		
		# Debug: Print linked points
#		print("Linked AStar graph setup complete!")

# Local function that generates unique IDs for cells
func _cell_to_id(cell: Vector2i) -> int:
	# Add a large offset to shift coordinates and ensure unique positive IDs
	return (cell.x + 50000) + (cell.y + 50000) * 100000

# Helper function to convert the point ID back to cell coordinates
func _id_to_cell(id: int) -> Vector2i:
	# Reverse the _cell_to_id transformation
	var x = (id % 100000) - 50000
	var y = (id / 100000) - 50000
	return Vector2i(x, y)

func _link_neighbors():
	# Iterate over all points in the AStar2D graph
	for cell_index in astar.get_point_ids():
		var cell = _id_to_cell(cell_index)  # Convert ID back to cell coordinates
		# Define neighbor offsets for orthogonal movement
		var neighbor_offsets = [
			Vector2i(1, 0),   # Right
			Vector2i(-1, 0),  # Left
			Vector2i(0, 1),   # Down
			Vector2i(0, -1)   # Up
		]
		
		for offset in neighbor_offsets:
			var neighbor = cell + offset
			var neighbor_index = _cell_to_id(neighbor)
			
			# Connect to the neighbor if it exists in AStar2D and is not disabled
			if astar.has_point(neighbor_index) and not astar.is_point_disabled(neighbor_index):
				if not astar.are_points_connected(cell_index, neighbor_index):
					astar.connect_points(cell_index, neighbor_index)
	queue_redraw()

func _add_exit_collider(location : Vector2, parent : Node2D):
	var area = Area2D.new()
	area.add_to_group("exits")
	var collision_shape_node = CollisionShape2D.new();
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = 30.0
	collision_shape_node.set_shape(circle_shape);
	area.add_child(collision_shape_node)
	parent.add_child(area)

#Debug stuff
func _draw():
	# Draw connections and points for debugging
	for point_id in astar.get_point_ids():
		var point_pos = astar.get_point_position(point_id)
		for neighbor_id in astar.get_point_connections(point_id):
			var neighbor_pos = astar.get_point_position(neighbor_id)
			# Draw a line between the point and its neighbor
			draw_line(point_pos, neighbor_pos, Color(1, 0, 0))  # Red lines for connections

		# Draw the point itself
		var color = Color(0, 1, 0) if not astar.is_point_disabled(point_id) else Color(1, 0, 0)
		draw_circle(point_pos, 5, color)  # Green for walkable, red for non-walkable

		# Draw the ID and coordinates of the point
		var tile_coords = _id_to_cell(point_id)  # Convert point_id back to coordinates
		var label = "Coords: (%d, %d)" % [tile_coords.x, tile_coords.y]
		draw_string(font, point_pos + Vector2(0, -15), label, 0, -1, 12, Color(1, 1, 1))  # Draw label slightly above the point
