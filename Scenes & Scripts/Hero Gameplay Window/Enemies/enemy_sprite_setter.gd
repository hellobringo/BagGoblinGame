extends Sprite2D

@export var sprite_sheets : Array[Texture]

#THIS STUFF IS UNUSED RN, MAYBE MANUAL ANIM SETUP IS BETTER
@export_group("anim frames start and end")
@export var idle : Vector2i
@export var run : Vector2i
@export var attack : Vector2i
@export var hurt : Vector2i
@export var die : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_spawn(type : Enemy.type):
	pass
