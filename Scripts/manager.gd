class_name Manager
extends Node2D

@onready var tscn_exp : PackedScene = load("res://Scenes/experiment.tscn")
@onready var label : Label = $InitText

var exp_order : Array = []
var order_int : int
var start_first : bool = true
var start_second : bool = false
var color_exp_script : Array = [
	[0, 1], [3, 1], [3, 2], [3, 2], [1, 3], 
	[2, 1], [2, 1], [1, 2], [3, 1], [0, 3], 
	[3, 0], [2, 0], [0, 1], [3, 1], [1, 0], 
	[3, 1], [0, 2], [2, 3], [0, 2], [2, 1], 
	[1, 0], [1, 2], [1, 2], [0, 1], [3, 2]
	]
var word_exp_script : Array = [
	[1, 0], [0, 3], [3, 1], [0, 1], [1, 0], 
	[1, 3], [1, 3], [2, 3], [2, 1], [3, 2], 
	[2, 0], [3, 0], [1, 0], [1, 2], [2, 3], 
	[1, 2], [3, 2], [2, 3], [3, 2], [2, 1], 
	[2, 3], [0, 2], [1, 3], [2, 0], [3, 2]
	]
var scn

func init(exp : int) -> void:
	order_int = exp
	if exp == 0:
		exp_order.append("find_from_color.json")
		exp_order.append("find_from_word.json")
	else:
		exp_order.append("find_from_word.json")
		exp_order.append("find_from_color.json")
	pass

func _physics_process(delta: float) -> void:
	if start_first && Input.is_action_just_pressed("ui_accept"):
		start_first = false
		scn = tscn_exp.instantiate()
		if order_int == 0:
			scn.init(exp_order[0], color_exp_script, false, self)
		else:
			scn.init(exp_order[0], word_exp_script, false, self)
		self.add_child(scn)
		label.visible = false
	
	if start_second && Input.is_action_just_pressed("ui_accept"):
		start_second = false
		scn = tscn_exp.instantiate()
		if order_int == 0:
			scn.init(exp_order[1], word_exp_script, true, null)
		else:
			scn.init(exp_order[1], color_exp_script, true, null)
		self.add_child(scn)
		label.visible = false

func start_second_exp():
	scn.queue_free()
	start_second = true
	label.visible = true
