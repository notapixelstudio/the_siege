extends Node

var btn_commander
var btn_carpenter
var btn_wizard

var ctn_message
var message_label

var btn_cards = []
var game_node

var counselor_id
#back card
var path_cards = ["res://assets/cards/commander_card_back.png", "res://assets/cards/carpenter_card_back.png" , "res://assets/cards/wizard_card_back.png"]
func _ready():
	
	game_node = get_node("/root/Game")
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

func do_show_cards(regnant):
	var counselors_id = [] 
	# get three cards for each chosen counselour
	var container_hand
	print(regnant.name)
	if regnant.name == "King":
		container_hand = get_node("cnt_king_hand")
	else:
		container_hand = get_node("cnt_queen_hand")
	container_hand.show()
	
	#apply texture
	var i = 0
	for card in regnant.hand:
		var card_button = container_hand.get_child(i)
		card_button.texture_normal = card.image_back
		counselor_id = regnant.summons
		var func_to_be_called = "_on_card_pressed"
		card_button.connect("pressed", get_node("/root/Game"), func_to_be_called, [regnant.id, i]) 
		i+=1
		
		btn_cards.append(card_button)
	
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
	
func enable_all_cards(regnant):
	var container_hand
	if regnant.name == "King":
		container_hand = get_node("cnt_king_hand")
	else:
		container_hand = get_node("cnt_queen_hand")
	var i = 0
	for card in regnant.hand:
		var card_button = container_hand.get_child(i)
		card_button.texture_normal = card.image_front
		card_button.disabled = false
		card_button.show()
		i += 1
		#counselor_id = regnant.summons
			
		
func hide_all_cards():
	get_node("cnt_king_hand").hide()
	get_node("cnt_queen_hand").hide()
		
func show_all_cards():
	get_node("cnt_king_hand").show()
	get_node("cnt_queen_hand").show()

	
func update_ui(this_round,this_turn):
	var string = this_turn + " turn: #" + str(this_round)
	print("UI: printed ->" + string) 
	get_node("ctn_turn/turn_label").text = string 

func do_flip_cards(regnant):
	enable_all_cards(regnant)
	
		
func reset_cards():
	btn_cards = []
	