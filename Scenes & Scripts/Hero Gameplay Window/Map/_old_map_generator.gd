extends Node2D

# OLD CODE ! NOT IN USE ATM !

#
#		N [Not used]
#	   *----------*
#	    \          \
#	w[0] \          \	E [2]
#	      \          \
#	       *----------*
#		        S[1]

@export var y_offset : float = 171
@export var x_offset : float = 243

var tile : PackedScene = preload("res://Scenes & Scripts/Hero Gameplay Window/Map/tile.tscn")



#for ref only
func old_spawn_path_tiles(amount : int) -> Array[Tile] :
	var _tiles : Array[Tile] = []
	var _previous_tile_location : Vector2 = Vector2.ZERO
	var _previous_tile_dir : int = -1
	var _dir : int = -1
	for i in amount :
		var _new_tile : Tile = tile.instantiate()
		add_child(_new_tile)
		_tiles.append(_new_tile)
		
		_dir = randi_range(0, 2)
		while _dir == _previous_tile_dir : #disallow tiles to overlap an existing tile
			_dir = randi_range(0, 2) # West = 0 , South = 1 , East = 2 , (path tiles never go north)
		
		var _this_tile_offset : Vector2
		match _dir :
			0: # west
				_this_tile_offset = Vector2(x_offset * -1, y_offset)
				_previous_tile_dir = 2
			1: # south
				_this_tile_offset = Vector2(x_offset, y_offset)
				_previous_tile_dir = -1 #doesn't matter. can't go north anyways
			2: # east
				_this_tile_offset = Vector2(x_offset, y_offset * -1) 
				_previous_tile_dir = 0
		_new_tile.position = _this_tile_offset + _previous_tile_location
		
		if i == 0 :
			_new_tile.position = Vector2.ZERO
		
		_previous_tile_location = _new_tile.position
		
	return _tiles
