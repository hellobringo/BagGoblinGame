extends hero_state

var _destination : Vector2i # map cell
var _path
var _next_cell


# Called by a StateMachine once it is ready.
func _state_machine_ready() -> void:
	me.exiting_map_piece.connect(on_map_piece_exit)
	pass


# Called by a StateMachine when the state is entered.
func _enter_state(old_state, state_data: Dictionary):
	print("State entered :", me.state_machine.state)
	
	var _current_pos = me.map.world_to_cell(me.global_position)
	var _target_pos = me.map.world_to_cell(me.map.get_exit(me.map.spawned_map_pieces[me.current_map_piece]))
	print("_current_pos", _current_pos, "_target_pos", _target_pos)
	_path = me.map.astar.get_point_path(me.map._cell_to_id(_current_pos),me.map._cell_to_id(_target_pos), true)
	_next_cell = _path[0]
	pass

func _physics_process(delta: float) -> void:
	if not _path or not _next_cell :
		return
	if me.position.distance_to(_next_cell) < 2:
		me.position = _next_cell
		if not _path or len(_path) == 1:
			pass
		else:
			_next_cell = _path[1]
			_path.remove_at(1)
	else:
		var motion = Vector2(_next_cell.x - me.position.x, _next_cell.y - me.position.y)
		me.velocity = motion.normalized() * me.MOTION_SPEED
		me.move_and_slide()
	me.flip_character_left_or_right()

func on_map_piece_exit():
	me.state_machine.set_state("find_enemy")

func _process(delta: float) -> void:
	pass

# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	pass
