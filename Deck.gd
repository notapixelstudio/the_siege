var all_cards = {
  'carpenter': {
    'build_wall': {
      name: 'Build wall',
      effects_shape: [
        {effect: 'raise_wall', pos: Vector2( 0,-1)},
        {effect: 'raise_wall', pos: Vector2( 0, 0)},
        {effect: 'raise_wall', pos: Vector2( 0, 1)}
      ]
    }
  },
  'commander': {
    'rain_of_arrows': {
      name: 'Rain of Arrows',
      effects_shape: [
        {effect: 'kill_pawn', pos: Vector2( 0,-1)},
        {effect: 'kill_pawn', pos: Vector2( 0, 0)},
        {effect: 'kill_pawn', pos: Vector2( 0, 1)}
      ]
    }
  },
  'wizard': {
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
  var counselor_id
  var cards

  func _init(counselor_id):
    self.counselor_id = counselor_id

    if counselor_id == 'carpenter':
      add('build_wall')
      add('build_wall')
      add('build_wall')
    elif counselor_id == 'commander':
      add('rain_of_arrows')
      add('rain_of_arrows')
      add('rain_of_arrows')
    elif counselor_id == 'wizard':
      add('fireball')
      add('fireball')
      add('fireball')

    # TBD shuffle

  func add(card_name):
    self.cards.append(all_cards[self.counselor_id][card_name])

  func draw(amount):
    var hand = []
    for i in range(amount):
      hand.append(self.cards.pop())

    return hand
    