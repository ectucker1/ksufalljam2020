extends RayCast2D

var velocity := Vector2()
var attack_damage := 10
var rotation_speed := 0


func _ready():
	rotation_speed = randf() * 200 - 100


func _physics_process(delta):
	rotation_degrees += rotation_speed * delta
	cast_to = velocity * delta
	force_raycast_update()
	var collider = get_collider()
	if collider in get_tree().get_nodes_in_group("players"):
		collider.status.health -= attack_damage
		queue_free()
	else:
		position += cast_to


func _on_Timeout_timeout():
	queue_free()
