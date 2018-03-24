extends Node2D

onready var grid_size = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y)
var cell_size = 48
var coord = Vector2(0,0)

func _ready():

	pass

func _input(event):
	if (event is InputEventMouseMotion):
		var pos = Vector2(int(event.global_position.x/cell_size), int(event.global_position.y/cell_size))
		if pos != coord:
			coord = pos
			print(coord)
			
			
		