extends Node2D

var HealthUnit
var hus = []

func setup(amount):
	var x = -(amount*9)/2
	
	HealthUnit = load('res://HealthUnit.tscn')
	for i in range(amount):
		var hu = HealthUnit.instance()
		hu.switch_on()
		hu.position.x = x
		hus.append(hu)
		add_child(hu)
		x += 9
		
func update(amount):
	var i = 0
	for hu in hus:
		if i < amount:
			hu.switch_on()
		else:
			hu.switch_off()
		i += 1