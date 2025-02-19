extends hero_state

#1. select random enemy spawn
#2. walk towards it
#3. enemies will enter vision
#4. first enemy = target enemy
#5. go towards enemy
#6. when enemy in range, set state to Attack

var _destination : Vector2i # map cell
var _path
var _next_cell
var target_enemy : Enemy

# Called by a StateMachine once it is ready.
func _state_machine_ready() -> void:
	if not me.initialized : me._initialize_player()
	pass


# Called by a StateMachine when the state is entered.
func _enter_state(old_state, state_data: Dictionary):
#	var global_enemy_spawn_positions : Array[Vector2] = me.map.get_enemy_spawn_positions(me.map.spawned_map_pieces[me.current_map_piece])
#	var enemy_spawn_cells : Array[Vector2i] = []
#	for pos in global_enemy_spawn_positions :
#		enemy_spawn_cells.append(me.map.world_to_cell(pos))
#	var random_position = enemy_spawn_cells[randi() % enemy_spawn_cells.size()]
#	print("enemy spawn positions", enemy_spawn_cells)
	if is_map_empty(me.map.spawned_map_pieces[me.current_map_piece]) :
		me.state_machine.set_state("go_to_next_map_piece")
		return
	me.animator.play("run")
	call_deferred("set_path_to_target_enemy")


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

func set_path_to_target_enemy():
	if me.current_map_piece == 0 :
		return
	var enemies_on_map = me.map.enemies_on_map[me.map.spawned_map_pieces[me.current_map_piece]]
	target_enemy = enemies_on_map.pick_random()
	if target_enemy != null :
		var _current_pos = me.map.world_to_cell(me.global_position)
		var _target_pos = me.map.world_to_cell(target_enemy.global_position)
		_path = me.map.astar.get_point_path(me.map._cell_to_id(_current_pos),me.map._cell_to_id(_target_pos), true)
		print(_current_pos, _target_pos)
		_next_cell = _path[0]

func is_map_empty(map_piece) -> bool:
	return not me.map.enemies_on_map.has(map_piece) or me.map.enemies_on_map[map_piece].size() == 0

func _process(delta: float) -> void:
	#if hero.target_tile == null || hero.active_tile == null :
	#	push_error("Target tile not found on hero")
		return
	
	


# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	pass


func _on_enemy_finder_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		me.state_machine.set_state("attack")
	pass # Replace with function body.
