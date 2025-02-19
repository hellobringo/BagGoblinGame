extends Area2D

var enemies_in_vision = []  # This will act as our min-heap
@onready var hero: CharacterBody2D = $".."

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		enemies_in_vision.append(area.get_parent())
		print("found enemy")

func _on_area_exited(area: Area2D) -> void:
	if area in enemies_in_vision:
		enemies_in_vision.erase(area)
