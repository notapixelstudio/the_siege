var all_cards = {
  'Carpenter': {
    'build_wall': {
      name: 'Build wall',
      effects_shape: [
        {effect: 'raise_wall', pos: Vector2( 0,-1)},
        {effect: 'raise_wall', pos: Vector2( 0, 0)},
        {effect: 'raise_wall', pos: Vector2( 0, 1)}
      ]
    }
  },
  'Commander': {
    'rain_of_arrows': {
      name: 'Rain of Arrows',
      effects_shape: [
        {effect: 'kill_pawn', pos: Vector2( 0,-1)},
        {effect: 'kill_pawn', pos: Vector2( 0, 0)},
        {effect: 'kill_pawn', pos: Vector2( 0, 1)}
      ]
    }
  },
  'Wizard': {
    'fireball': {
      name: 'Fireball',
      effects_shape: [
        {effect: 'kill_pawn', pos: Vector2( 0,-1)},
        {effect: 'kill_pawn', pos: Vector2(-1, 0)},
        {effect: 'kill_pawn', pos: Vector2( 0, 0)},
        {effect: 'kill_pawn', pos: Vector2( 1, 0)},
        {effect: 'kill_pawn', pos: Vector2( 0, 1)}
      ]
    }
  }
}

class Deck:
  var counselor_name
  var cards
  var Card

  func _init(counselor_name):
    self.Card = preload('res://Card.gd').new().Card

    self.counselor_name = counselor_name

    if counselor_name == 'Carpenter':
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
      add('build_wall')
    elif counselor_name == 'Commander':
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
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

    # TBD shuffle

  func add(card_id):
    var card_data = all_cards[self.counselor_name][card_id]
    self.cards.append(self.Card.new(self.counselor_name, card_id, card_data))

  func draw(amount):
    var hand = []
    for i in range(amount):
      hand.append(self.cards.pop())

    return hand
    