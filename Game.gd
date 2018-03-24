extends Node

const NUM_REGNANTS = 2
const NUM_COUNSELORS = 3

var regnants = []
var counselors = []
var regnants_alive = 2

enum roleRegnant {KING , QUEEN }
enum roleCounselor {COMMANDER , CARPENTER, WIZARD}

enum moods {HAPPY, QUIET, SAD, ANGRY}

var stringRegnant = ["King" , "Queen"]
var stringCounserlor = ["Commander" , "Carpenter", "Wizard"]


var num_rounds = 2;
var curr_round = 1;

class Counselor:
	var name
	var summoned_by
	var alive
	var mood
	
	func _init(var n):
		name = n
		summoned_by = null; 
		alive = true
		mood = HAPPY

class Regnant:
	var name
	var alive
	
	func _init(var n):
		name = n
		alive = true
 
		
func setup_game():

	for i in range(NUM_REGNANTS):
		regnants.append(Regnant.new(stringRegnant[i]))

	for i in range(NUM_COUNSELORS):
		counselors.append(Counselor.new(stringCounserlor[i]))



func _ready():
	print("setup")	
	setup_game()
	turn_AI()
	
func turn_AI():
	print("Turn AI")	
	attack()
	
func attack():
	print("attack")	
		
func spawn():
	print("spawn")
	
func move():
	print("move")


func _on_attack_done():
	spawn()

func _on_spawn_done():
	move()

func _on_move_done():
	turn_player()
	
	


func summon_counselor(i):
	var regnant = regnants[i]
	print("The " + regnant.name + " summons")
	get_node("UI/pickCounselor/VBoxContainer/title").text = "The " + regnant.name + " summons:"
	get_node("UI/pickCounselor").show();
	 
func show_cards():
	pass
	

func turn_player():
	print("Turn Player")
	summon_counselor(KING);

	#phase 1
	#summon counselors	
	
	#phase 2
	#show cards	
	
	#phase 3
	#pick cards
		#select target
		#execute actions

	
func _on_btn_commander_pressed():
	picked_counselor(COMMANDER)
	
func _on_btn_carpenter_pressed():
	picked_counselor(CARPENTER)
	 
func _on_btn_wizard_pressed():
	picked_counselor(WIZARD)

	
func picked_counselor(counselor):
	var id_regnant = get_node("UI/pickCounselor/VBoxContainer/id").text;
	
	counselors[counselor].summoned_by = int(id_regnant);
	print("you have been chosen by " + id_regnant)
	get_node("UI/pickCounselor").hide()
	
	if regnants_alive == 2 and int(id_regnant) == KING:
		summon_counselor(QUEEN)
	else:
		show_cards()	
	
	
 