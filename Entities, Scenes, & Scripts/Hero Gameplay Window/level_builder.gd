extends Node

@onready var hero: CharacterBody2D = $"../Hero"
@onready var map: DungeonMap = $"../Map"
@onready var enemy_factory: EnemyFactory = $"../Enemy Factory"

var map_piece_amount : int = 10 # Amount of map pieces that will be spawned
var hero_head_start : int = (map_piece_amount*.5) # Player will exit x amount of maps before spawning new pieces (& deleting old)


#Watch hero location and count how many exit tiles he's crossed


#Spawn new map pieces as the hero crosses enough exits
#Remove old map pieces & remove from astar

#Spawn enemies

func _ready() -> void:
	hero.exiting_map_piece.connect(_on_hero_exit_map_piece) # Listen for hero exiting map piece
	
	map.initialize()
	enemy_factory.initialize()
	
	for i in map_piece_amount : 
		map.spawned_map_pieces.append(map.spawn_random_map_piece())

func _on_hero_exit_map_piece(): # + Enters a new map piece
	if hero.current_map_piece < 6: hero.current_map_piece += 1
	_spawn_enemys(map.spawned_map_pieces[hero.current_map_piece])
	print("spawning enemies on map piece: ", hero.current_map_piece)
	if hero_head_start > 0 : hero_head_start -= 1
	else:
		_delete_map_piece()
		map.spawned_map_pieces.append(map.spawn_random_map_piece())

func _delete_map_piece():
	var piece_to_delete : TileMapLayer = map.spawned_map_pieces.pop_at(0)
	map.remove_from_astar(piece_to_delete)
	piece_to_delete.queue_free() #Destroy map piece

func _spawn_enemys(tilemaplayer : TileMapLayer):
	var enemy_spawn_positions : Array[Vector2] = map.get_enemy_spawn_positions(tilemaplayer)
	print("level_builder.enemy_spawn_positions = ", enemy_spawn_positions)
	for spawn_position in enemy_spawn_positions :
		enemy_factory.spawn_enemy(3, spawn_position, tilemaplayer)
		pass
