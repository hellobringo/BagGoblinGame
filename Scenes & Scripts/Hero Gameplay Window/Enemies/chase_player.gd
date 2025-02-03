extends StateNode

@onready var me : Enemy = $"../.."
var _hero_location : Vector2
var _vision_box : Rect2

# Called by a StateMachine once it is ready.
func _state_machine_ready() -> void:
	pass

# Called by a StateMachine when the state is entered.
func _enter_state(old_state, state_data: Dictionary):
	_hero_location = get_player_location()
	me.animator.play("run")
#	print("found!")
	pass

var last_x # track last x coord to flip sprite accordingly
func _process(delta: float) -> void:
	_slow_process(delta) #process, but runs slower to save performance
	last_x = me.position.x
	
	var move_target = _hero_location + Vector2.RIGHT * 25 if me.position.x > _hero_location.x else _hero_location + Vector2.LEFT * 25
	
	me.position = me.position.move_toward(move_target, delta * me.move_speed)
	
	if me.position.x > last_x:
		me.sprite.flip_h = true
		me.hitbox.scale.x = -1
		me.attack_range.scale.x = -1
	else :
		me.sprite.flip_h = false
		me.hitbox.scale.x = 1
		me.attack_range.scale.x = 1


#----
var _process_every : float = .2 #run process every X seconds
var _process_timer_elapsed : float = randf_range(0, _process_every)
func _slow_process(delta):
	_process_timer_elapsed += delta
	if _process_every <= _process_timer_elapsed :
		_process_timer_elapsed = 0 #reset timer
		_hero_location = get_player_location()
		for collision in me.attack_range.get_overlapping_areas() :
			if collision.is_in_group("hero"):
				me._state_machine.enter_state("attack")

func get_player_location() -> Vector2 :
	return me._hero.position

# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	pass
