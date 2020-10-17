extends Camera2D


const MAX_X := 1.0
const MAX_Y := 1.0

const MAX_ROT := 0.05

var noise: OpenSimplexNoise

var time = 0.0


func _ready():
	noise = OpenSimplexNoise.new()
	
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 0.3
	noise.persistence = 0.4

func _process(delta):
	time += delta
	var shake = GlobalEffects.trauma * GlobalEffects.trauma * GlobalConsts.player.status.screenshake_mult
	offset_h = shake * noise.get_noise_2d(0, time) * MAX_X
	offset_v = shake * noise.get_noise_2d(1, time) * MAX_Y
	global_rotation = shake * noise.get_noise_2d(2, time) * MAX_ROT
