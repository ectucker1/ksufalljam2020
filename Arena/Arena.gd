extends TileMap

onready var enemy_scene := preload("res://Enemy/Enemy.tscn")


func _ready():
	spawn_enemy()


func spawn_enemy():
	var enemy = enemy_scene.instance()
	add_child(enemy)
