extends CharacterBody2D

@export var map: DungeonMap

const MOTION_SPEED = 200 # Pixels/second.
enum States { STOPPED, MOVING }
var _state = States.STOPPED
var _destination = Vector2()
var _next_cell = position
var _path : PackedVector2Array = []
@onready var area_2d: Area2D = $Area2D

@onready var label: Label = $Label
@onready var label2: Label = $Label2

signal exiting_map_piece

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
		_initialize_player()

func _initialize_player() -> void:
	# Ensure map and empty_tilemap are valid before proceeding
	if map != null and map.empty_tilemap != null:
		position = map.cell_to_world(Vector2i.ZERO)
		print("Player initialized at:", position)
	else:
		print("Failed to initialize player. 'map' or 'empty_tilemap' is null.")

func _process(delta: float) -> void:
	var mouse
	if get_global_mouse_position() != null : label.text = "Global mouse position: " + str(get_global_mouse_position())
	if get_global_mouse_position() != null : label2.text = "Converted to cell: " + str(map.world_to_cell(get_global_mouse_position()))

func _physics_process(_delta):
	if _state == States.MOVING:
		if position.distance_to(_next_cell) < 2:
			position = _next_cell
			if not _path or len(_path) == 1:
				_state = States.STOPPED
			else:
				_next_cell = _path[1]
				_path.remove_at(1)
		else:
			var motion = Vector2(_next_cell.x - position.x, _next_cell.y - position.y)
			velocity = motion.normalized() * MOTION_SPEED
			move_and_slide()

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
