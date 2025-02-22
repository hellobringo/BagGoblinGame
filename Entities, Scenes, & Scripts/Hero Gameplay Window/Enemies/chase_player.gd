extends StateNode

@onready var me : Enemy = $"../.."
var _hero_location : Vector2

@export var noise : Noise #maybe add randomness later

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
var offset : Vector2 = Vector2(randf_range(10,30), randf_range(-10, 10))
func _process(delta: float) -> void:
	_slow_process(delta) #process, but runs slower to save performance
	last_x = me.position.x
	
	var move_target = _hero_location + offset if me.position.x > _hero_location.x else _hero_location - offset
	
	
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
var _process_every : float = .5 #run process every X seconds
var _process_timer_elapsed : float = randf_range(0, _process_every)
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


func _on_attack_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("hero") and me._state_machine.get_state() == "chase_player" :
		me._state_machine.enter_state("attack")
