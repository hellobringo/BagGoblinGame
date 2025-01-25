extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var speed : float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_LEFT) :
		position.x -= 1 * speed
	if Input.is_key_pressed(KEY_RIGHT) :
		position.x += 1 * speed
	if Input.is_key_pressed(KEY_DOWN) :
		position.y += 1 * speed
	if Input.is_key_pressed(KEY_UP) :
		position.y -= 1 * speed
	pass
