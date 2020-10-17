extends TextureProgress


func _process(delta):
	if GlobalConsts.player != null:
		value = GlobalConsts.player.status.health
