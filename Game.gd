extends Node

const NUM_REGNANTS = 2
const NUM_COUNSELORS = 3

var regnants = []
var counselors = []

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

 
       

func attack():
	print("attack")
	
func spawn():
	print("spawn")
	
func move():
	print("move")
		
func turn_AI():
	attack()
	spawn()
	move()
	

func show_popup(regnant):
	print("The " + regnant.name + " summons")
	get_node("UI/pickCounselor/VBoxContainer/title").text = "The " + regnant.name + " summons:"
	get_node("UI/pickCounselor").show();
	 
	

func turn_player():

	#phase 1
	for i in range(len(regnants)):
		#show and pick counselor
		show_popup(regnants[i])
		
	
	#phase 2
	#for all consuelor
		#show cards
#	for i in range(NUM_COUNSELORS):
#		if counselors[i].summoned_by != null:
#			show_cards(counselors[i])


	
		
	#phase 3
	#for each consuelor
		#pick card
			#select target
			#execute actions
			 
	
		

func _ready():
 	
	setup_game()
 
	
	for i in range(num_rounds):
		print("round " + str(i))
		
		#turn 1
		turn_AI()
		
		turn_player()
		
		
		
		
		
		
	
	
	
	

func _on_btn_commander_pressed():
	
	var id_regnant = get_node("UI/pickCounselor/VBoxContainer/id").text;
	
	counselors[COMMANDER].summoned_by = int(id_regnant);
	print("you have been chosen by " + id_regnant)
	get_tree().paused = false
	get_node("UI/pickCounselor").hide()
	
	

func _on_btn_carpenter_pressed():
	var id_regnant = get_node("UI/pickCounselor/VBoxContainer/id").text;
	
	counselors[CARPENTER].summoned_by = int(id_regnant);
	print("you have been chosen by " + id_regnant)
	get_tree().paused = false
	get_node("UI/pickCounselor").hide()


func _on_btn_wizard_pressed():
	var id_regnant = get_node("UI/pickCounselor/VBoxContainer/id").text;
	
	counselors[WIZARD].summoned_by = int(id_regnant);
	print("you have been chosen by " + id_regnant)
	get_tree().paused = false
	get_node("UI/pickCounselor").hide()
