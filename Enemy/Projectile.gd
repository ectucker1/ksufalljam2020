extends RayCast2D

var velocity := Vector2()
var attack_damage = 10


func _physics_process(delta):
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
