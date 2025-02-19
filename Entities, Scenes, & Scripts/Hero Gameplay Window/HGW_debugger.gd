extends Node2D
@onready var map: DungeonMap = $"../Map"
@onready var label: Label = $Label
@onready var label_2: Label = $Label2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.position = get_global_mouse_position() + Vector2.ONE * 25
	label_2.position = label.position + Vector2(0, 15)
	
	label.text = str(get_global_mouse_position())
	label_2.text = str(map.cell_to_world(map.world_to_cell(get_global_mouse_position())))
	pass
