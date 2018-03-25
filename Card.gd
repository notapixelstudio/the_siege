class Card:
	var counselor_id
	var cursor_shape
	var type
	var id
	var name
	var res_front
	var res_back
	
	func _init(counselor_id, res):
		self.counselor_id = counselor_id
		self.res_front = res