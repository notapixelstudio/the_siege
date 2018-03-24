extends Node

const NUM_REGNANTS = 2
const NUM_COUNSELORS = 3

var regnants = []
var counselors = []

enum enum_regnant   {KING , QUEEN }
enum enum_counselor {COMMANDER , CARPENTER, WIZARD}
enum enum_turn      {AI, PLAYER}
enum enum_moods     {HAPPY, QUIET, SAD, ANGRY}

var regnant_dict	= {KING: "King" , QUEEN: "Queen"}
var counselor_dict 	= {COMMANDER : "Commander" , CARPENTER : "Carpenter", WIZARD: "Wizard"}
var turn_dict 		= {AI: "Enemy", PLAYER:"Player"}
var moods_dict 		= {HAPPY: "Happy", QUIET: "Quiet", SAD = "Sad", ANGRY = "Angry"}
 

var regnants_alive = 2
var num_rounds = 2;
var curr_round = 0;
var curr_turn = AI;



class Counselor:
	var name
	var summoned
	var alive
	var mood
	
	func _init(var n):
		name = n
		summoned = false
		alive = true
		mood = HAPPY

class Regnant:
	var name
	var alive
	var summons
	
	func _init(var n):
		name = n
		alive = true
 		
		
func setup_game():

	for i in range(NUM_REGNANTS):
		regnants.append(Regnant.new(regnant_dict[i]))

	for i in range(NUM_COUNSELORS):
		counselors.append(Counselor.new(counselor_dict[i]))

	get_node("UI/pickCounselor").hide()
	


func _ready():
	print("Game: Setup")
	setup_game()
	turn_AI()
	
	
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


func turn_player():
	print("Game: Round " + str(curr_round) + ", Turn Player") 	

	curr_turn = turn_dict[PLAYER]
	$UI.update_ui(curr_round,curr_turn)


	summon_counselor(KING);

	#phase 1
	#summon counselors	
	
	#phase 2
	#show cards	
	
	#phase 3
	#pick cards
		#select target
		#execute actions	
	


func summon_counselor(i):
	var regnant = regnants[i]
	$UI.do_show_popup_counselor(i,regnant.name)
	 
func show_cards():
	
	$UI.do_show_cards(regnants,counselors)
	

 
func _on_btn_commander_pressed():
	picked_counselor(COMMANDER)
	
func _on_btn_carpenter_pressed():
	picked_counselor(CARPENTER)
	 
func _on_btn_wizard_pressed():
	picked_counselor(WIZARD)

	
func picked_counselor(counselor):
	
	var id_regnant = int(get_node("UI/pickCounselor/VBoxContainer/id").text);
	
	print("GAME: The " + regnant_dict[id_regnant] + " summons the " + counselor_dict[counselor])
	
	regnants[id_regnant].summons = counselor;
	
	counselors[counselor].summoned = true;
	get_node("UI/pickCounselor").hide()
	
	
	if regnants_alive == 2 and id_regnant == KING:
		summon_counselor(QUEEN)
	else:
		show_cards()	
	