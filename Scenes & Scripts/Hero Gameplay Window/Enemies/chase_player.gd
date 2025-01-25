extends StateNode

@onready var me : Enemy = $"../.."
var _hero_location : Vector2

# Called by a StateMachine once it is ready.
func _state_machine_ready() -> void:
	pass


# Called by a StateMachine when the state is entered.
func _enter_state(old_state, state_data: Dictionary):
	_hero_location = get_player_location()
#	print("found!")
	pass


func _process(delta: float) -> void:
	_slow_process(delta) #process, but runs slower to save performance
	me.position = me.position.move_toward(_hero_location, me.move_speed)

var _process_every : float = .5 #run process every X seconds
var _process_timer_elapsed : float = 0
func _slow_process(delta):
	_process_timer_elapsed += delta
	if _process_every <= _process_timer_elapsed :
		_process_timer_elapsed = 0 #reset timer
		_hero_location = get_player_location()

func get_player_location() -> Vector2 :
	return me._hero.position

# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	pass
