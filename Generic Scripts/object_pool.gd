extends Node
class_name Object_pool

@export var scene : PackedScene
var pool : Array = []

func add_to_pool(object: Node2D) : 
	pool.append(object)
	object.set_process(false)
	object.set_physics_process(false)
	object.hide()

func pull_from_pool() -> Node2D:
	var object : Node2D
	if pool.is_empty():
		object = scene.instantiate()
	else:
		object = pool.pop_back()
	object.set_process(true)
	object.set_physics_process(true)
	object.show()
	return object
