extends Node

#  Usage:
#	Inherit from this script & add custom attack logic
#	Remember to add super._ready()
#	Attach inherited script onto a node2d on the enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().attack.connect("on_attack_signal")
	pass # Replace with function body.
