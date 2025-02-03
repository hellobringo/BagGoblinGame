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

var last_x
func _process(delta: float) -> void:
	_slow_process(delta) #process, but runs slower to save performance
	last_x = me.position.x
	me.position = me.position.move_toward(_hero_location, delta * me.move_speed)
	
	if me.position.x > last_x:
		me.sprite.flip_h = true
		me.hitbox.scale.x = -1
	else :
		me.sprite.flip_h = false
		me.hitbox.scale.x = 1


#----
var _process_every : float = .5 #run process every X seconds
var _process_timer_elapsed : float = 0
func _slow_process(delta):
	_process_timer_elapsed += delta
	if _process_every <= _process_timer_elapsed :
		_process_timer_elapsed = 0 #reset timer
		_hero_location = get_player_location()
		_vision_box = Rect2(me.position, Vector2.ONE * me.attack_within_range)
		_vision_box = _vision_box.abs()
		if _vision_box.has_point(_hero_location) :
			me._state_machine.set_state("attack")

func get_player_location() -> Vector2 :
	return me._hero.position

# Called by a StateMachine when the state is exited.
func _exit_state(new_state, state_data: Dictionary):
	pass
