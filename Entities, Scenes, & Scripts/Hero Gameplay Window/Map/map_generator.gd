extends Node2D

#Map pieces or basically rooms are spawned a
@export var map_pieces : Array[PackedScene] = []
var previously_placed_map_piece : TileMapLayer = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
