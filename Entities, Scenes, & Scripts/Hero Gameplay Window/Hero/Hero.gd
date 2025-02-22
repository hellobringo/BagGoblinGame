extends CharacterBody2D
class_name Hero

@export var map: DungeonMap # set in hero gameplay window

const MOTION_SPEED = 200 # Pixels/second.
enum States { STOPPED, MOVING }
var _state = States.STOPPED
var _destination = Vector2()
var _next_cell = position
var _path : PackedVector2Array = []
var current_map_piece : int = 0
var initialized : bool = false

@onready var state_machine: StateMachine = $StateMachine
@onready var hurtbox: Area2D = $hurtbox
@onready var hitbox: Area2D = $hitbox
@onready var enemy_finder: Area2D = $enemy_finder
@onready var animator : AnimationPlayer = $animator
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var label: Label = $Label
@onready var label2: Label = $Label2

signal exiting_map_piece

var previous_x : float

func _ready() -> void:
	# First, check if 'map' itself is valid
	if map == null:
		print("Error: 'map' is not assigned!")
		return
	
	# Defer initialization if 'empty_tilemap' is not ready
	if map.empty_tilemap == null:
		print("empty_tilemap is not initialized. Deferring initialization...")
		call_deferred("_initialize_player")
	else:
		print("empty_tilemap is ready!")
	
	if not initialized : _initialize_player()


func _initialize_player() -> void:
	# Ensure map and empty_tilemap are valid before proceeding
	if map != null and map.empty_tilemap != null:
		position = map.cell_to_world(Vector2i.ZERO)
		print("Player initialized at:", position)
	else:
		print("Failed to initialize player. 'map' or 'empty_tilemap' is null.")
	previous_x = position.x
	initialized = true
	state_machine = $StateMachine

func _process(delta: float) -> void:
	if get_global_mouse_position() != null : label.text = "Global mouse position: " + str(get_global_mouse_position())
	if get_global_mouse_position() != null : label2.text = "Converted to cell: " + str(map.world_to_cell(get_global_mouse_position()))


#flip character based on previous x position
func flip_character_left_or_right():	
	if previous_x < position.x :
		hitbox.scale.x = 1
		sprite_2d.flip_h = false
		enemy_finder.scale.x = 1
	else : if previous_x > position.x :
		hitbox.scale.x = -1
		sprite_2d.flip_h = true
		enemy_finder.scale.x = -1
	previous_x = position.x

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		_destination = map.world_to_cell(get_global_mouse_position())
		var current_pos = map.world_to_cell(position)
		_path = map.astar.get_point_path(map._cell_to_id(current_pos),map._cell_to_id(_destination), true)
#		print(_path)
		_next_cell = _path[0]
		_state = States.MOVING

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("exits"):
		exiting_map_piece.emit()
		area.remove_from_group("exits")
