extends Node2D
class_name Enemy

@export var hp : int = 1
@export var attack_speed : float = 1
@export var move_speed : float = 1

@onready var sprite : Sprite2D = $Sprite2D

@onready var _state_machine : StateMachine = $StateMachine
var _despawn_cooldown_duration = 2
var _despawn_timer_elapsed = 0

var _hero : Node2D

signal despawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	found_hero()
	pass # Replace with function body.

func spawn():
	if (sprite != null):
		sprite.visible = true
	sprite.modulate = Color.WHITE

func _process(delta: float) -> void:
	pass
#	_test_movement()

func found_hero() :
	_state_machine.enter_state("chase_player")
