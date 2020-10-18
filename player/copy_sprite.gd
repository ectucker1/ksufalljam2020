extends Sprite


export var sprite_path: NodePath
var sprite


func _ready():
	sprite = get_node(sprite_path)

func _process(delta):
	visible = sprite.visible
	frame = sprite.frame
