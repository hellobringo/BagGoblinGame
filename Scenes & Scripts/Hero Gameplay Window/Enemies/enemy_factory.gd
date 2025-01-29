extends Node
class_name EnemyFactory

var pool : Object_pool = Object_pool.new()

@export var base_enemy_scene : PackedScene
@onready var _hero : Node2D = $"../Hero"

# Called when the node enters the scene tree for the first time.
func initialize() -> void:
	pool.scene = base_enemy_scene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_enemy(amount : int, position : Vector2):
	for i in amount:
		var enemy : Enemy = pool.pull_from_pool()
		enemy._hero = _hero
		enemy.global_position = position
		add_child(enemy)
		enemy.spawn()
	pass

func _send_enemy_back_to_pool():
	pass
