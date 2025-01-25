extends hero_state



# Called by a StateMachine once it is ready.
func _state_machine_ready() -> void:
	pass


# Called by a StateMachine when the state is entered.
func _enter_state(old_state, state_data: Dictionary):
	pass

func _process(delta: float) -> void:
	#if hero.target_tile == null || hero.active_tile == null :
	#	push_error("Target tile not found on hero")
		return
	
	


# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	pass
