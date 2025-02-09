extends Node
class_name EnemyFactory

var pool : Object_pool = Object_pool.new()

@export var base_enemy_scene : PackedScene

@onready var _hero : Node2D = $"../Hero"
@onready var map: DungeonMap = $"../Map"

# Called when the node enters the scene tree for the first time.
func initialize() -> void:
	pool.scene = base_enemy_scene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_enemy(amount : int, position : Vector2, map_piece : TileMapLayer) -> Array[Enemy]: #add arg ", type : Array[Enemy.type]" ?
	var array : Array[Enemy] = []
	for i in amount:
		var enemy : Enemy = pool.pull_from_pool()
		array.append(enemy)
		enemy._hero = _hero
		enemy.global_position = position + Vector2.ONE * (randi() % 50)
		add_child(enemy)
		enemy.spawn(map_piece)
		#Map : Enemy dictionary stuff
		if not map.enemies_on_map.has(map_piece): map.enemies_on_map[map_piece] = []  # Initialize an empty array for this map piece
		map.enemies_on_map[map_piece].append(enemy)
	return array



func _send_enemy_back_to_pool(enemy : Enemy):
	#Map : Enemy dictionary stuff
	var map_piece = enemy.current_map_piece
	if map.enemies_on_map.has(map_piece):
		map.enemies_on_map[map_piece].erase(enemy)
		if map.enemies_on_map[map_piece].size() == 0:
			map.enemies_on_map.erase(map_piece)  # Remove the key if no enemies are left
