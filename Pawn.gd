extends KinematicBody2D

var direction = Vector2()
const TOP = Vector2(0, -1)
const RIGHT = Vector2(1, 0)
const DOWN = Vector2(0, -1)
const LEFT = Vector2(-1, 0)


const MAX_SPEED = 3

var speed = 0
var velocity = Vector2()

var facing = Vector2()
var target_pos = Vector2()
var target_direction = Vector2()
var last_target_direction = Vector2()
var is_moving = false

var type
var battlefield


func _ready():
	battlefield = get_parent()
	type = battlefield.PAWN
	
	
func _physics_process(delta):
	speed = 0
	
	if not is_moving and direction != Vector2():
		target_direction = direction
		if battlefield.is_cell_vacant(position, target_direction):
			target_pos = battlefield.update_child_pos(self)
			is_moving = true
		else:
			stop()
	elif is_moving:
		speed = MAX_SPEED
		velocity = speed * target_direction
		var pos = position
		var distance_to_target = Vector2(abs(target_pos.x - position.x), abs(target_pos.y - pos.y))
		if abs(velocity.x) > distance_to_target.x: 
			velocity.x = distance_to_target.x * target_direction.x
			is_moving = false

		if abs(velocity.y) > distance_to_target.y: 
			velocity.y = distance_to_target.y * target_direction.y
			is_moving = false
		move_and_collide(velocity)
	
	last_target_direction = target_direction
	
func march():
	direction = facing

func stop():
	direction = Vector2()
	
func break_walls():
	battlefield.break_cell(position, last_target_direction)