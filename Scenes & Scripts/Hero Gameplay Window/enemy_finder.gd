extends Node

@onready var area2d : Area2D = $Area2D


func find_enemy() :
	area2d.get_overlapping_areas()
