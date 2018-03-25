extends Node

const NUM_REGNANTS = 2
const NUM_COUNSELORS = 3
const MAX_ROUNDS = 10
const MAX_CARDS =3



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
var curr_round = 0
var curr_turn = AI
var curr_regnant = KING


enum enum_player_state {SETUP,AI_ATTACK, AI_SPAWN, AI_MOVE, AI_END_TURN, P_BEGIN, P_SUMMON_C1,P_SUMMON_C2, P_PICKED_C1,P_PICKED_C2, P_FLIP_C,P_EXEC_C1,P_EXEC_C2,P_END_TURN,P_END_GAME }
var game_state = SETUP



var these_cards = []
var regnants = []
var counselors = []

class Counselor:
	var name
	var id
	var summoned
	var alive
	var mood
	var cards = []
	const MAX_CARDS = 3
	
	func _init(n, id, cards_dict):
		var Card = preload("res://Card.gd").new().Card
		name = n
		self.id = id
		summoned = false
		alive = true
		mood = HAPPY
		for i in range(MAX_CARDS):
			cards.append(Card.new(self.id, cards_dict[self.id]))
		print(cards)

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
	print("Game: Setup")
	game_state = SETUP
	for i in range(NUM_REGNANTS):
		regnants.append(Regnant.new(regnant_dict[i], i))
	for i in range(NUM_COUNSELORS):
		counselors.append(Counselor.new(counselor_dict[i], i, cards_dict))
	$UI.hide_message()

func _ready():
	setup_game()
	turn_AI()

func turn_AI():
	# turn AI:
	# 1. attack
	# 2. spawn
	# 3. everybody moves
	curr_round +=1
	curr_turn = turn_dict[AI]

	$UI.hide_all_cards()
	$UI.disable_counsellors()
	$UI.update_ui(curr_round,curr_turn)

	print("Game: Round " + str(curr_round) + ", Turn AI")
	attack()
	

func attack():
	print("Game: do_attack")
	game_state = AI_ATTACK
	$Battlefield.do_attack()
	
func spawn():
	print("Game: do_spawn")
	game_state = AI_SPAWN
	$Battlefield.do_spawn()
	
func move():
	print("Game: do_move")
	game_state = AI_MOVE
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
	#Change state
	
	game_state = P_BEGIN
	curr_turn = turn_dict[PLAYER]
	#print log info
	print("Game: Round " + str(curr_round) + ", Turn Player")
	#clean temporary variables
	these_cards = []
	curr_regnant = KING;
	#update ui
	$UI.update_ui(curr_round,curr_turn)
	$UI.enable_counsellors()
	$UI.reset_cards()
	
	#next action
	summon_counselor(curr_regnant)
	
func summon_counselor(id):
	#Change state
	if game_state == P_BEGIN:
		if regnants_alive == 2:
			game_state = P_SUMMON_C1
		else:
			game_state = P_SUMMON_C2
	if game_state == P_PICKED_C1:
		game_state = P_SUMMON_C2
		
	#print log info
	print("Summon a counselor")
	# update ui
	var regnant = regnants[id]
	$UI.do_show_popup_counselor(id,regnant.name)

func _on_btn_commander_pressed():
	picked_counselor(COMMANDER)
	
func _on_btn_carpenter_pressed():
	picked_counselor(CARPENTER)
	 
func _on_btn_wizard_pressed():
	picked_counselor(WIZARD)

func picked_counselor(counselor):
	#Change state
	if game_state == P_SUMMON_C1: 
		if regnants_alive == 2: 
			game_state = P_PICKED_C1
		else:
			game_state = P_PICKED_C2
	elif game_state == P_SUMMON_C2:
			game_state = P_PICKED_C2
			
		
	
	#Print log info
	print("GAME: The " + regnant_dict[curr_regnant] + " summons the " + counselor_dict[counselor])


	$UI.hide_message()

	#A Regnant picked a counselor. Show its cards
	regnants[curr_regnant].summons = counselor
	counselors[counselor].summoned = true
	show_cards(regnants[curr_regnant], counselors[counselor])

	# save the cards for now
	for i in range(MAX_CARDS):
		these_cards.append(counselors[counselor].cards[i])

	if game_state == P_PICKED_C1 and regnants_alive == 2:
		curr_regnant = QUEEN
		summon_counselor(curr_regnant)
		
		
	# show and choose cards
	if game_state == P_PICKED_C2:
		$UI.disable_counsellors()
		flip_cards(these_cards)
		print(these_cards)



func show_cards(regnant, counselor):
	$UI.do_show_cards(regnant,counselor)

func get_cards(counselor):
	return counselor.cards

func flip_cards(cards):
	print("GAME: flip the cards")
	
	game_state = P_FLIP_C
	$UI.disable_counsellors()
	
	$UI.do_flip_cards(cards)
	
func player_end_turn():

	game_state = P_END_TURN
	turn_AI()
	pass
	
func player_execute_cards(counselor_id):
	
	if game_state == P_FLIP_C:
		if regnants_alive == 2:
			game_state = P_EXEC_C1
		else:
			game_state = P_EXEC_C2
	else:
		if game_state == P_EXEC_C1:
			game_state = P_EXEC_C2
			
	#DO some stuff
	#TODO here I choose hardcoded the card of the counselor. change it
	if game_state == P_EXEC_C1:
		$Battlefield.set_cursor_shape(these_cards[0])
		#TODO disable only three cards
	else:
		$Battlefield.set_cursor_shape(these_cards[3])
		#TODO disable only three cards

	if game_state == P_EXEC_C2:
		player_end_turn()
	
	
# Player turn ATTACK
func _on_btn_attackcommander_pressed():
	player_execute_cards(COMMANDER)
	
func _on_btn_attackcarpenter_pressed():
	player_execute_cards(CARPENTER) 
	
func _on_btn_attackwizard_pressed():
	player_execute_cards(WIZARD)

	