extends TileMap

onready var enemy_scene := preload("res://Enemy/Enemy.tscn")


func _ready():
	randomize()
	show_wheel()


func start_wave(num_enemies = 3):
	for i in range(3):
		spawn_enemy()


func spawn_enemy():
	# spawn an enemy on a random point in the enemy spawn path
	var enemy = enemy_scene.instance()
	$EnemySpawnPath/PathFollow2D.unit_offset = randf()
	enemy.position = $EnemySpawnPath/PathFollow2D.position
	add_child(enemy)


func show_wheel():
	$WheelLayer/Wheel.show()


func _on_Wheel_visibility_changed():
	if !$WheelLayer/Wheel.visible:
		start_wave(3)
