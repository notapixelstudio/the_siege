extends Node

var cards = []
var path_cards = ["res://assets/cards/commander_card_back.png", "res://assets/cards/carpenter_card_back.png" , "res://assets/cards/wizard_card_back.png"]
func _ready():

	var btn_commander = get_node("TextureCommander")
	var btn_carpenter = get_node("TextureCarpenter")
	var btn_wizard = get_node("TextureWizard")

	btn_commander.connect("pressed",get_node("/root/Game"),"_on_btn_commander_pressed")
	btn_carpenter.connect("pressed",get_node("/root/Game"),"_on_btn_carpenter_pressed")
	btn_wizard.connect("pressed",get_node("/root/Game"),"_on_btn_wizard_pressed")
	
	# TODO: need for every card action
	var btn_action = get_node("TextureCard1")
	btn_action.connect("pressed", get_node("/root/Game"),"_on_btn_action_pressed")

func do_show_popup_counselor(i,name):
	var text = "The "+ name +" requires to talk with ... (choose a counselour)"
	print("UI: do_show_popup_counselor, by the " + name)
	update_message(text)
	show_message()

func update_message(text):
	get_node("message").text = text

func hide_message():
	get_node("message").hide()
	
func show_message():
	get_node("message").show()

func do_show_cards(regnant,counselor):
	var counselors_id = [] 
	# get three cards for each chosen counselour
	print("UI: do_show_cards, for counselor "+ counselor.name)
	var card1 
	var card2 
	var card3
	
	if regnant.name == "King": 
		# get cards for king
		card1 = get_node("TextureCard1")
		card2 = get_node("TextureCard2")
		card3 = get_node("TextureCard3")
		
	elif regnant.name == "Queen":
		# get cards for king
		card1 = get_node("TextureCard4")
		card2 = get_node("TextureCard5")
		card3 = get_node("TextureCard6")
		
	# show them
	card1.show()
	card2.show()
	card3.show()
	
	#apply texture
	card1.texture_normal = load(path_cards[counselor.id])
	card2.texture_normal = load(path_cards[counselor.id])
	card3.texture_normal = load(path_cards[counselor.id])
	
	# store cards
	cards.append(card1)
	cards.append(card2)
	cards.append(card3)
	
	
func update_ui(this_round,this_turn):
	var string = this_turn + " turn: #" + str(this_round)
	print("UI: printed ->" + string) 
	get_node("turn_label").text = string 

func do_flip_cards(cards):
	var i = 1
	for card in cards:
		get_node("TextureCard"+str(i)).texture_normal = load(card.res_front)
		i+=1
	pass
	