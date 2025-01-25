extends StateNode

@onready var me : Enemy = $"../.."

# Called by a StateMachine once it is ready.
func _state_machine_ready() -> void:
	pass


# Called by a StateMachine when the state is entered.
func _enter_state(old_state, state_data: Dictionary):
	pass


# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	pass

func _process(delta: float) -> void:
	_wait_and_wander(delta)



#region wait and wander vars
var waiting : bool = true
@export var wait_min : float = .5
@export var wait_max : float = 4
var wait_time : float = randf_range(wait_min, wait_max)
var wait_elapsed : float = 0
var random_direction : Vector2 = Vector2(randf_range(-1,1),randf_range(-1,1))

@export var move_time_min : float = .5
@export var move_time_max : float = 2
var move_duration : float = randf_range(wait_min, wait_max)
var move_time_elapsed : float = 0
#endregion
func _wait_and_wander(delta):
	if waiting :
		wait_elapsed += delta
		if wait_elapsed >= wait_time :
			wait_elapsed = 0
			wait_time = randf_range(wait_min, wait_max)
			waiting = false
			random_direction = Vector2(randf_range(-1,1),randf_range(-1,1))
	if not waiting :
		me.position = me.position.move_toward(me.position + random_direction, me.move_speed * .5)
		move_time_elapsed += delta
		if move_time_elapsed >= move_duration :
			waiting = true
			move_time_elapsed = 0
