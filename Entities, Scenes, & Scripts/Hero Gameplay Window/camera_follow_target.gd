extends Camera2D

@export var target : Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target :
		self.position = lerp(position, target.position, .5)
	pass
