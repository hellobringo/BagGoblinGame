extends Node2D
class_name DungeonMap

@export var map_pieces : Array[PackedScene] = []
#@export var tilemap_node_path: NodePath  # Path to the TileMap node
@export var font: SystemFont  # Assign a DynamicFont resource for text drawing
var astar := AStar2D.new()
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var empty_tilemap : TileMapLayer = $TileMapLayer
var previous_exit_cell : Vector2i = Vector2i.ZERO

#	Terms:
#	Cell - An isometric square of the tile map
#		They are represented by a vector2i i.e. Vector2i(0, 1) 
#	ID - Arbitrary id number for astar to differentiate points
#
#
 
var _pieces : int = 3
func _ready():
	for i in _pieces:
		spawn_random_map_piece()
		queue_redraw()


func spawn_random_map_piece():
	var random_index = randi() % map_pieces.size()
	if random_index >= 0 and random_index < map_pieces.size():
		var piece_scene = map_pieces[random_index]
		if piece_scene:
			var instance = piece_scene.instantiate() as TileMapLayer
			if previous_exit_cell != Vector2i.ZERO:
				var exit_world_position = tile_to_world(previous_exit_cell)  # Convert exit cell to world position
				instance.position = exit_world_position  # Position the new piece at the previous exit
			add_and_link_astar(instance)
			empty_tilemap.add_child(instance)
			print("Spawned level piece at position: ", instance.position)
		else:
			print("Piece at index ", random_index, " is invalid.")
	else:
		print("Invalid piece index: ", random_index)
	pass



func add_and_link_astar(tilemaplayer : TileMapLayer):
	if tilemaplayer:
		var used_cells = tilemaplayer.get_used_cells()  # Get all cells in this layer
		var layer_offset = world_to_cell(tilemaplayer.position) + Vector2i(0, 1)  # Calculate the offset in cell coordinates
		
		for cell in used_cells:
			var adjusted_cell = cell + layer_offset  # Adjust cell coordinates with the offset
			var walkable = tilemaplayer.get_cell_tile_data(cell).get_custom_data("walkable")
			var is_exit = tilemaplayer.get_cell_tile_data(cell).get_custom_data("exit")
			var local_pos = tilemaplayer.map_to_local(cell)
			var world_pos = tilemaplayer.to_global(local_pos)  # Convert to global space
			var cell_index = _cell_to_id(adjusted_cell)  # Generate a unique index for this cell
			# Add the cell to AStar2D
			astar.add_point(cell_index, world_pos)
			# Disable the point if it's not walkable
			if not walkable:
				astar.set_point_disabled(cell_index, true)
			if is_exit:
				previous_exit_cell = adjusted_cell
		_link_neighbors()
		
		# Debug: Print linked points
		print("Linked AStar graph setup complete!")


#		------------Important functions for other things to use in the game----------

func tile_to_world(tile_coords: Vector2i) -> Vector2:
	var local_pos = empty_tilemap.map_to_local(tile_coords) # Convert tile to local position
	return empty_tilemap.to_global(local_pos)  # Convert local position to world space

func world_to_cell(world_position: Vector2) -> Vector2i:
#	tilemap_layer
	var local_position = empty_tilemap.to_local(world_position) # Convert world to local space
	return empty_tilemap.local_to_map(local_position)  # Convert local position to map (tile) coordinates

func tile_to_local(tile_coords: Vector2i) -> Vector2:
	return empty_tilemap.map_to_local(tile_coords)  # Converts tile coordinates to local position

#						----------End of public functions----------------

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
