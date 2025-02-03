extends StateNode
@onready var me: Enemy = $"../.."


# Called by a StateMachine once it is ready.
func _state_machine_ready() -> void:
	pass


# Called by a StateMachine when the state is entered.
func _enter_state(old_state, state_data: Dictionary):
	me.animator.play("attack")
	me.animator.animation_finished.connect(attack_finished)
	pass

func attack_finished():
	me._state_machine.set_state("chase_player")

# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	pass
