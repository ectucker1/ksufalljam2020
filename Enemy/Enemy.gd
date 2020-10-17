extends KinematicBody2D

enum EnemyType { LB, BS, DS, JD }

enum AttackType { MELEE, RANGED }

var enemy_type = EnemyType.LB
var attack_type = AttackType.MELEE
var speed := 50

var knockback_velocity := Vector2()
var knockback_damp := 60

var melee_distance := 25
var melee_attack := 10

var projectile_speed := 100

var health := 20
var dead := false
var spawning := true

var arena : Node2D
var nav : Navigation2D
var player : Player
onready var projectile := preload("res://Enemy/Projectile.tscn")


func _ready():
	add_to_group("enemies")
	arena = get_node("../../Arena")
	if arena:
		nav = arena.get_node("Nav")
	load_resources()


func _physics_process(delta):
	if knockback_velocity != Vector2.ZERO:
		move_and_slide(knockback_velocity)
		knockback_velocity = knockback_velocity.clamped(
				knockback_velocity.length() - knockback_damp * delta)
		if knockback_velocity.length() < 5:
			knockback_velocity = Vector2.ZERO
	
	else:
		player = get_tree().get_nodes_in_group("players")[0]
		follow_player(delta)


func load_resources():
	match enemy_type:
		EnemyType.LB:
			$Sprite.frames = load("res://Enemy/LB_SpriteFrames.tres")
			attack_type = AttackType.MELEE
		EnemyType.BS:
			$Sprite.frames = load("res://Enemy/BS_SpriteFrames.tres")
			attack_type = AttackType.RANGED
		EnemyType.DS:
			$Sprite.frames = load("res://Enemy/DS_SpriteFrames.tres")
			attack_type = AttackType.MELEE
		EnemyType.JD:
			$Sprite.frames = load("res://Enemy/JD_SpriteFrames.tres")


func follow_player(delta):
	# Skip if the level's navigation node doesn't exist or if dead
	if !nav or dead or spawning:
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
			var direction = position.direction_to(path[0])
			face_direction(direction)
			move_and_collide(direction * distance_walk)
		
		else:
			face_direction(position.direction_to(path[0]))
			move_and_collide(path[0] - position)
			path.remove(0)
		
		distance_walk -= distance_point
	
	match attack_type:
		AttackType.MELEE:
			# attack if close enough
			if position.distance_to(player.position) < melee_distance:
				melee_attack()
		
		AttackType.RANGED:
			# attack if within sight
			if $SightArea.overlaps_body(player):
				# use raycast to make sure no obstacles are in the way
				$SightArea/Ray.cast_to = player.position - position
				$SightArea/Ray.force_raycast_update()
				if $SightArea/Ray.get_collider() == player:
					ranged_attack($SightArea/Ray.cast_to.normalized())


func face_direction(direction : Vector2):
	if abs(direction.x) > abs(direction.y) / 2:
		if direction.x > 0 and $Sprite.animation != "walk_right":
			$Sprite.animation = "walk_right"
		elif direction.x < 0 and $Sprite.animation != "walk_left":
			$Sprite.animation = "walk_left"
	else:
		if direction.y > 0 and $Sprite.animation != "walk_down":
			$Sprite.animation = "walk_down"
		elif direction.y < 0 and $Sprite.animation != "walk_up":
			$Sprite.animation = "walk_up"


func melee_attack():
	# Don't attack if an animation is still playing (this serves as a cooldown)
	if $MeleeArea/Anim.is_playing():
		return
	
	# The attack animation enables the area's collision
	$MeleeArea.look_at(player.position)
	$MeleeArea/Anim.play("attack")


func ranged_attack(direction : Vector2):
	if $RangedAttackCooldown.is_stopped():
		var p = projectile.instance()
		p.position = position + direction
		p.velocity = direction * projectile_speed
		get_parent().add_child(p)
		$RangedAttackCooldown.start()


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
		player.status.health -= melee_attack


func _on_Anim_animation_finished(anim_name):
	if anim_name == "die":
		# enemy is dead
		queue_free()
	
	elif anim_name == "spawn":
		spawning = false


func _on_SpawnDelay_timeout():
	$Anim.play("spawn")
