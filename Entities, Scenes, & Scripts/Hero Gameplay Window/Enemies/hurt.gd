extends StateNode

@onready var me : Enemy = $"../.."

# Called by a StateMachine once it is ready.
func _state_machine_ready() -> void:
	pass


# Called by a StateMachine when the state is entered.
func _enter_state(old_state, state_data: Dictionary):
	me.hp -= 1
	if !me.animator.animation_finished.is_connected(on_animation_finished) : me.animator.animation_finished.connect(on_animation_finished)
	if me.hp <= 0 :
		me._state_machine.set_state("die")
	else :
		me.animator.play("hurt")
	pass

func on_animation_finished(anim_name):
	if me.hp <= 0 :
		me._state_machine.set_state("die")
	else :
		me._state_machine.set_state("chase_player")
	

# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	me.animator.animation_finished.disconnect(on_animation_finished)
	pass
