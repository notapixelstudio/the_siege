extends Node2D

func switch_on():
	set_state(true)
	
func switch_off():
	set_state(false)
	
func set_state(on):
	if on:
		$AnimatedSprite.play('on')
	else:
		$AnimatedSprite.play('off')
		