class Card:
	var counselor_id
	var effects_shape
	var type
	var id
	var name
	var res_front
	var res_back
	
	func _init(counselor_id, res):
		self.counselor_id = counselor_id
		self.res_front = res
		
	func resolve(battlefield, pos):
		for effect_tile in effects_shape:
			battlefield.call(effect_tile.effect,effect_tile.pos)
			