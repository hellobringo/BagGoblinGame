extends StateNode
@onready var me: Enemy = $"../.."

# Called by a StateMachine once it is ready.
func _state_machine_ready() -> void:
	pass

# Called by a StateMachine when the state is entered.
func _enter_state(old_state, state_data: Dictionary):
	me.animator.animation_finished.connect(attack_finished)
	me.animator.play("attack")
	pass

func attack_finished(anim_name):
	var collisions = me.attack_range.get_overlapping_areas()
	if collisions.size() == 0 :
		me._state_machine.set_state("chase_player")
	for collision in collisions :
		if collision.is_in_group("hero"):
			me._state_machine.enter_state("attack")
		else : 
			me._state_machine.set_state("chase_player")

# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	me.animator.animation_finished.disconnect(attack_finished)
	pass
