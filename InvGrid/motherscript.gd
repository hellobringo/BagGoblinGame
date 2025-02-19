extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.pressed.connect(self.add_item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_item():
	var rng = RandomNumberGenerator.new()
	var my_random_number = round(rng.randf_range(0, 3))
	var myitemload = load("res://InvGrid/my_item.tscn")
	var myInstance = myitemload.instantiate()
	$myNode/CanvasLayer/GridDrawer/allItems.add_child(myInstance)
	myInstance.myImage = str(my_random_number)
	myInstance.justAdded = true
