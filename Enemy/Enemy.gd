extends KinematicBody2D

enum Type {  # placeholder enemy types
	NONE, ZOMBIE, DOG, BIRD
}

var type = Type.NONE
var speed := 50
var melee_distance := 25

var health := 20
var dead := false

var arena : Node2D
var nav : Navigation2D
var player : KinematicBody2D


func _ready():
	add_to_group("enemies")
	arena = get_node("../../Arena")
	if arena:
		nav = arena.get_node("Nav")


func _physics_process(delta):
	player = get_tree().get_nodes_in_group("players")[0]
	follow_player(delta)


func follow_player(delta):
	# Skip if the level's navigation node doesn't exist or if dead
	if !nav or dead:
		return
	
	# Find a path to the player
	var path = nav.get_simple_path(position, player.position)
	
	# Calculate this frame's walking distance
	var distance_walk = speed * delta
	
	# Move until there's no more distance to walk
	while distance_walk > 0 and path.size() > 0:
		# Determine distance to next point
		var distance_point = position.distance_to(path[0])
		
		if distance_walk < distance_point:
			move_and_collide(position.direction_to(path[0]) * distance_walk)
		
		else:
			move_and_collide(path[0] - position)
			path.remove(0)
		
		distance_walk -= distance_point
	
	# Attack if close enough
	if position.distance_to(player.position) < melee_distance:
		melee_attack()


func melee_attack():
	# Don't attack if an animation is still playing (this serves as a cooldown)
	if $MeleeArea/Anim.is_playing():
		return
	
	# The attack animation enables the area's collision
	$MeleeArea.look_at(player.position)
	$MeleeArea/Anim.play("attack")


func take_damage(amount := 5):
	health -= amount
	if health > 0:
		$Anim.play("hurt")
	else:
		die()


func die():
	dead = true
	$Anim.play("die")


func _on_MeleeArea_body_entered(body):
	if body == player:
		# TODO: deal damage
		pass


func _on_Anim_animation_finished(anim_name):
	if anim_name == "die":
		# enemy is dead
		queue_free()
