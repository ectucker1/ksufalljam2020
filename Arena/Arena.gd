extends Node2D

enum EnemyType { LB, BS, DS, JD }

var wave := 1

onready var enemy_scene := preload("res://Enemy/Enemy.tscn")


func _ready():
	randomize()
	show_wheel()


func start_wave(num_enemies = 3):
	for i in range(num_enemies):
		spawn_enemy(randi() % EnemyType.size(), i * .5)


func spawn_enemy(enemy_type, delay = 0):
	# spawn an enemy on a random point in the enemy spawn path
	var enemy = enemy_scene.instance()
	$EnemySpawnPath/PathFollow2D.unit_offset = randf()
	enemy.position = $EnemySpawnPath/PathFollow2D.position
	enemy.enemy_type = enemy_type
	enemy.get_node("SpawnDelay").wait_time = clamp(delay, .01, delay)
	enemy.connect("died", self, "on_enemy_died")
	add_child(enemy)


func show_wheel():
	$WheelLayer/Wheel.show()


func _on_Wheel_visibility_changed():
	if !$WheelLayer/Wheel.visible:
		start_wave(wave + 2)


func on_enemy_died():
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		$WheelLayer/Wheel.show_screen()
		wave += 1
		$HudLayer/Control/WaveLabel.text = "Wave " + str(wave)
		if $Player.status.health < 70:
			$Player.status.health = 70
