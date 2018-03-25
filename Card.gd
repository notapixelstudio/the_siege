class Card:
	var counselor_name
	var effects_shape
	var id
	var name
	var image_front
	var image_front_disabled
	var image_back
	
	func _init(counselor_name, id, data):
		self.counselor_name = counselor_name
		self.id = id
		self.name = data.name
		self.effects_shape = data.effects_shape
		self.image_front = load('res://assets/cards/'+counselor_name+'_card_front.png')
		self.image_front_disabled = load('res://assets/cards/'+counselor_name+'_card_front_disabled.png')
		self.image_back = load('res://assets/cards/'+counselor_name+'_card_back.png')

	func get_shape():
		var shape = []
		for effect_tile in effects_shape:
			shape.append(effect_tile.pos)

		return shape
		
	func resolve(battlefield, pos):
		for effect_tile in effects_shape:
			battlefield.call(effect_tile["effect"], effect_tile["pos"] + pos)
			