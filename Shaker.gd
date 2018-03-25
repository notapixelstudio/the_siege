extends Node

const duration = 0.18
const magnitude = 3
var initial_offset
onready var camera = get_parent()
var time = 0

func _ready():
	pass

func shake():
	initial_offset = camera.get_offset()
	while time < duration:
		time += get_process_delta_time()
		time = min(time, duration)
		var offset  = Vector2()
		offset = rand_range(-magnitude, magnitude)
		offset = rand_range(-magnitude, magnitude)
		camera.set_offset(initial_offset + offset)
	time = 0
	camera.set_offset(initial_offset)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
