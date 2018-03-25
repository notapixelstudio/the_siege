class Deck:
	var counselor_name
	var cards = []
	var Card
	var all_cards = {
		'Carpenter': {
			'small_wall': {
				'name': 'Small Wall',
				'effects_shape': [
					{'effect': 'raise_wall', 'pos': Vector2( 0,-1)},
					{'effect': 'raise_wall', 'pos': Vector2( 0, 0)}
				]
			},
			'tiny_wall': {
				'name': 'Tiny Wall',
				'effects_shape': [
					{'effect': 'raise_wall', 'pos': Vector2( 0, 0)}
				]
			},
			'thick_wall': {
				'name': 'Thick Wall',
				'effects_shape': [
					{'effect': 'raise_wall', 'pos': Vector2( 0, 0)},
					{'effect': 'raise_wall', 'pos': Vector2( 0, 1)},
					{'effect': 'raise_wall', 'pos': Vector2( 1, 0)},
					{'effect': 'raise_wall', 'pos': Vector2( 1, 1)}
				]
			}
		},
		'Commander': {
			'rain_of_arrows': {
				'name': 'Rain of Arrows',
				'effects_shape': [
					{'effect': 'kill_pawn', 'pos': Vector2( 0,-1)},
					{'effect': 'kill_pawn', 'pos': Vector2( 0, 0)},
					{'effect': 'kill_pawn', 'pos': Vector2(-1, 0)}
				]
			},
			'desperate_shot': {
				'name': 'Desperate Shot',
				'effects_shape': [
					{'effect': 'kill_pawn', 'pos': Vector2(-1,-1)},
					{'effect': 'kill_pawn', 'pos': Vector2( 0, 0)}
				]
			}
		},
		'Wizard': {
			'fireball': {
				'name': 'Fireball',
				'effects_shape': [
					{'effect': 'kill_pawn', 'pos': Vector2( 0,-1)},
					{'effect': 'kill_pawn', 'pos': Vector2(-1, 0)},
					{'effect': 'kill_pawn', 'pos': Vector2( 0, 0)},
					{'effect': 'kill_pawn', 'pos': Vector2( 1, 0)},
					{'effect': 'kill_pawn', 'pos': Vector2( 0, 1)}
				]
			}
		}
	}

	func _init(counselor_name):
		self.Card = preload('res://Card.gd').new().Card

		self.counselor_name = counselor_name

		if counselor_name == 'Carpenter':
			add('thick_wall')
			add('thick_wall')
			add('thick_wall')
			
			add('small_wall')
			add('small_wall')
			add('small_wall')
			add('small_wall')
			add('small_wall')
			add('small_wall')
			
			add('tiny_wall')
			add('tiny_wall')
			add('tiny_wall')
			add('tiny_wall')
			add('tiny_wall')
			add('tiny_wall')
			add('tiny_wall')
			add('tiny_wall')
			add('tiny_wall')
			
		elif counselor_name == 'Commander':
			add('desperate_shot')
			add('desperate_shot')
			add('desperate_shot')
			add('desperate_shot')
			add('desperate_shot')
			add('desperate_shot')
			add('desperate_shot')
			add('desperate_shot')
			add('desperate_shot')
			add('desperate_shot')
			add('desperate_shot')
			add('desperate_shot')

			add('rain_of_arrows')
			add('rain_of_arrows')
			add('rain_of_arrows')
			add('rain_of_arrows')
			add('rain_of_arrows')
			add('rain_of_arrows')
			add('rain_of_arrows')
			add('rain_of_arrows')
			add('rain_of_arrows')
			
		elif counselor_name == 'Wizard':
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')
			add('fireball')

		self.cards = shuffleList(self.cards)

	func add(card_id):
		var card_data = all_cards[self.counselor_name][card_id]
		self.cards.append(self.Card.new(self.counselor_name, card_id, card_data))

	func draw(amount):
		var hand = []
		for i in range(amount):
			hand.append(self.cards.pop_front())

		return hand
		
# from https://godotengine.org/qa/2547/how-to-randomize-a-list-array
func shuffleList(list):
	var shuffledList = []
	var indexList = range(list.size())
	for i in range(list.size()):
			randomize()
			var x = randi()%indexList.size()
			shuffledList.append(list[x])
			indexList.remove(x)
			list.remove(x)
	return shuffledList