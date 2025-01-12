extends Node2D
class_name Enemy

@export var hp : int
@export var attack_speed : float
@export var move_speed : float

@onready var sprite : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp >= 0 :
		_die()
	pass

func _die():
	pass
