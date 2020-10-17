extends KinematicBody2D

enum Type {  # placeholder enemy types
	NONE, ZOMBIE, DOG, BIRD
}

export(Type) var type = Type.NONE
var speed := 50

var arena : Node2D
var nav : Navigation2D


func _ready():
	arena = get_node("../../Arena")
	if arena:
		nav = arena.get_node("Nav")


func _physics_process(delta):
	follow_player(delta)


func follow_player(delta):
	if !nav: return
	
	var player = get_tree().get_nodes_in_group("players")[0]
	
	var path = nav.get_simple_path(position, player.position)
	
	var collision : KinematicCollision2D
	var distance_walk = speed * delta
	
	while distance_walk > 0 and path.size() > 0:
		# determine distance to next point
		var distance_point = position.distance_to(path[0])
		
		if distance_walk < distance_point:
			collision = move_and_collide(position.direction_to(path[0]) * distance_walk)
		
		else:
			collision = move_and_collide(path[0] - position)
			path.remove(0)
		
		distance_walk -= distance_point
	
	if collision:
		print(collision)
