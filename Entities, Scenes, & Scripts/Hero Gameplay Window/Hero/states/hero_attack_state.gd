extends hero_state

var _destination : Vector2i # map cell
var _path
var _next_cell


# Called by a StateMachine once it is ready.
func _state_machine_ready() -> void:
	pass


# Called by a StateMachine when the state is entered.
func _enter_state(old_state, state_data: Dictionary):
	print("HERO ENTERED ATTACK STATE")
	me.animator.animation_finished.connect(attack_finished)
	me.animator.play("attack")
	pass

func attack_finished(_anim):
	var collisions = me.enemy_finder.get_overlapping_areas()
	if collisions.size() == 0 :
		me.state_machine.set_state("find_enemy")
	for collision in collisions :
		if collision.is_in_group("enemy"):
			me.state_machine.enter_state("attack")
		else : 
			me.state_machine.set_state("find_enemy")

# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	me.animator.animation_finished.disconnect(attack_finished)
	pass
