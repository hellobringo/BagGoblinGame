extends Node2D
class_name Enemy

# ENEMY SETUP INFO
#	Animations
#Every enemy should have animations named exactly:
#	idle, run, attack, hurt, die
# *maybe hurt isnt necessary
#Set up the animations with the AnimationPlayer, add a new track for property "frame" of the sprite sheet
#	attack animation :
#		change the property of "hitboxshape" -> "Disabled" to enable and disable the hitbox for enemy attacks

@export_group("Stats")
@export var hp : int = 1
@export var attack_speed : float = 1
@export var move_speed : float = 1
@export var attack_within_range : float 

@onready var sprite : Sprite2D = $Sprite2D
@onready var _state_machine : StateMachine = $StateMachine
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Area2D = $hurtbox
@onready var hitbox: Area2D = $hitbox

enum type {skeleton, tiger, crystal_lizard, fish_horse, wizard}
@export var enemy_type : type

signal died # Enemy factory will listen to this in order to send enemy back to object pool

var _hero : Node2D

#DEBUG
@onready var chase_player: Node = $StateMachine/chase_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	found_hero()
	pass # Replace with function body.

func spawn(): #Set up enemy type here
	match type:
		type.skeleton :
			sprite.on_spawn(enemy_type)

func _process(delta: float) -> void:
	queue_redraw()
	pass

func found_hero() :
	_state_machine.enter_state("chase_player")

func _draw():
	if chase_player._vision_box != null :
		var global_rect2 = Rect2(to_global(chase_player._vision_box.position), chase_player._vision_box.size)
		draw_rect(chase_player._vision_box, Color.WHITE)
