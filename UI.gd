extends Node

var btn_commander
var btn_carpenter
var btn_wizard

var ctn_message
var message_label

var btn_cards = []

var path_cards = ["res://assets/cards/commander_card_back.png", "res://assets/cards/carpenter_card_back.png" , "res://assets/cards/wizard_card_back.png"]
func _ready():

	btn_commander = get_node("TextureCommander")
	btn_carpenter = get_node("TextureCarpenter")
	btn_wizard = get_node("TextureWizard")

	btn_commander.connect("pressed",get_node("/root/Game"),"_on_btn_commander_pressed")
	btn_carpenter.connect("pressed",get_node("/root/Game"),"_on_btn_carpenter_pressed")
	btn_wizard.connect("pressed",get_node("/root/Game"),"_on_btn_wizard_pressed")
	
	ctn_message = get_node("ctn_message")
	message_label = get_node("ctn_message/message")


func do_show_popup_counselor(i,name):
	var text = "The "+ name +" requires to talk with ... (choose a counselour)"
	print("UI: do_show_popup_counselor, by the " + name)
	update_message(text)
	show_message()

func update_message(text):
	message_label.text = text

func hide_message():
	ctn_message.hide()
	
func show_message():
	ctn_message.show()

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
	
	if (counselor.id == 0):
		card1.connect("pressed",get_node("/root/Game"),"_on_btn_attackcommander_pressed")
		card2.connect("pressed",get_node("/root/Game"),"_on_btn_attackcommander_pressed")
		card3.connect("pressed",get_node("/root/Game"),"_on_btn_attackcommander_pressed")
	elif(counselor.id == 1):
		card1.connect("pressed",get_node("/root/Game"),"_on_btn_attackcarpenter_pressed")
		card2.connect("pressed",get_node("/root/Game"),"_on_btn_attackcarpenter_pressed")
		card3.connect("pressed",get_node("/root/Game"),"_on_btn_attackcarpenter_pressed")
	elif(counselor.id == 3):
		card1.connect("pressed",get_node("/root/Game"),"_on_btn_attackwizard_pressed")
		card2.connect("pressed",get_node("/root/Game"),"_on_btn_attackwizard_pressed")
		card3.connect("pressed",get_node("/root/Game"),"_on_btn_attackwizard_pressed")
	
	
	
	btn_cards.append(card1);
	btn_cards.append(card2);
	btn_cards.append(card3);
	
	
	
	
func disable_counsellors():	
	btn_commander.disabled = true
	btn_carpenter.disabled = true
	btn_wizard.disabled = true 
	
func enable_counsellors():	
	btn_commander.disabled = false
	btn_carpenter.disabled = false
	btn_wizard.disabled = false
 
func disable_all_cards():
	for card in btn_cards:
		card.disabled = true
	
func enable_all_cards():
	for card in btn_cards:
		card.disabled = false
		
		
func hide_all_cards():
	for card in btn_cards:
		card.hide()
		
func show_all_cards():
	for card in btn_cards:
		card.show()

	
func update_ui(this_round,this_turn):
	var string = this_turn + " turn: #" + str(this_round)
	print("UI: printed ->" + string) 
	get_node("ctn_turn/turn_label").text = string 

func do_flip_cards(cards):
	var i = 1
	for card in cards:
		get_node("TextureCard"+str(i)).texture_normal = load(card.res_front)
		i+=1
	enable_all_cards()
	
		
func reset_cards():
	
	btn_cards = []
	
	