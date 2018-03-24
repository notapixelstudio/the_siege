extends Node

const NUM_REGNANTS = 2
const NUM_COUNSELORS = 3

var regnants = []
var counselors = []

enum enum_regnant   {KING , QUEEN}
enum enum_counselor {COMMANDER , CARPENTER, WIZARD}
enum enum_turn      {AI, PLAYER}
enum enum_moods     {HAPPY, QUIET, SAD, ANGRY}

# mapping enum to string
var regnant_dict	= {KING: "King" , QUEEN: "Queen"}
var counselor_dict 	= {COMMANDER : "Commander" , CARPENTER : "Carpenter", WIZARD: "Wizard"}
var turn_dict 		= {AI: "Enemy", PLAYER:"Player"}
var moods_dict 		= {HAPPY: "Happy", QUIET: "Quiet", SAD = "Sad", ANGRY = "Angry"}
var cards_dict = {COMMANDER: "res://assets/cards/commander_card_front.png", CARPENTER: "res://assets/cards/carpenter_card_front.png", WIZARD:"res://assets/cards/wizard_card_front.png"}
 
var regnants_alive = 2
var num_rounds = 4
var curr_round = 0
var curr_turn = AI
var curr_regnant = KING

var MAX_CARDS=3

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
		
class Counselor:
	var name
	var id
	var summoned
	var alive
	var mood
	var cards = []
	
	func _init(n, id, cards_dict):
		name = n
		self.id = id
		summoned = false
		alive = true
		mood = HAPPY
		for i in range(3):
			cards.append(Card.new(self.id, cards_dict[self.id]))

class Regnant:
	var name
	var id
	var alive
	var summons
	
	func _init(n,id):
		name = n
		self.id = id
		alive = true
		
func setup_game():
	for i in range(NUM_REGNANTS):
		regnants.append(Regnant.new(regnant_dict[i], i))
	for i in range(NUM_COUNSELORS):
		counselors.append(Counselor.new(counselor_dict[i], i, cards_dict))
	
func _ready():
	print("Game: Setup")
	setup_game()
	turn_AI()
	# turn AI: 
	# 1. attack
	# 2. spawn
	# 3. everybody moves
func turn_AI():
	curr_round +=1
	curr_turn = turn_dict[AI]
	print("Game: Round " + str(curr_round) + ", Turn AI") 	
	$UI.update_ui(curr_round,curr_turn)
	attack()
	
func attack():
	print("Game: do_attack")
	$Battlefield.do_attack()
	
func spawn():
	print("Game: do_spawn")
	$Battlefield.do_spawn()
	
func move():
	print("Game: do_move")
	$Battlefield.do_move()

# from signal attack_done
func _on_attack_done():
	spawn()

# from signal spawn_done
func _on_spawn_done():
	move()

# from signal move_done
func _on_move_done():
	turn_player()
	
"""
# turn PLAYER:
#phase 1
#summon counselors

#phase 2
#show cards

#phase 3
#pick cards
#select target
#execute actions
"""

func turn_player():
	print("Game: Round " + str(curr_round) + ", Turn Player")
	curr_turn = turn_dict[PLAYER]
	$UI.update_ui(curr_round,curr_turn)
	summon_counselor(curr_regnant)
	
func summon_counselor(id):
	var regnant = regnants[id]
	$UI.do_show_popup_counselor(id,regnant.name)
	 
func show_cards(regnant, counselor):
	$UI.do_show_cards(regnant,counselor)
	
func _on_btn_commander_pressed():
	picked_counselor(COMMANDER)
	
func _on_btn_carpenter_pressed():
	picked_counselor(CARPENTER)
	 
func _on_btn_wizard_pressed():
	picked_counselor(WIZARD)

# from card chos
func _on_btn_action_pressed():
	print("GAME: Card picked, starting Player attack")
	# get_node("UI/chooseCards").hide()
	turn_AI()
	
func get_cards(counselor):
	return counselor.cards

func picked_counselor(counselor):
	print("GAME: The " + regnant_dict[curr_regnant] + " summons the " + counselor_dict[counselor])
	regnants[curr_regnant].summons = counselor
	counselors[counselor].summoned = true
	show_cards(regnants[curr_regnant], counselors[counselor])

	$UI.hide_message()	
	if regnants_alive == 2 and curr_regnant == KING:
		curr_regnant = QUEEN
		summon_counselor(curr_regnant)
		
	if curr_regnant == QUEEN:
		# show and choose cards
		#flip_cards(these_cards)
		pass
		
func flip_cards(cards):
	print("GAME: flip the cards")
	$UI.do_flip_cards(cards)