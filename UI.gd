extends Node

func _ready():
	pass

func do_show_popup_counselor(i,name):
	
	print("The " + name + " summons")
	get_node("pickCounselor/VBoxContainer/title").text = "The " + name + " summons:"
	get_node("pickCounselor/VBoxContainer/id").text = str(i);
	get_node("pickCounselor").show();
	 