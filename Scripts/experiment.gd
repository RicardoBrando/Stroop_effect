class_name Experiment
extends Node2D

@onready var timer : Timer = $WaitForCard
@onready var scn_card : PackedScene = load("res://Scenes/card.tscn")
@onready var label : Label = $StartText

var manager : Manager
var exp_type : String

var user_index : int
var save : bool

var colors : Array = [null, null, null, null]
var words : Array = [null, null, null, null]
var exp_script : Array

var card_index : int = -1
var once : bool = true
var end = false

var times : Array = []

var card : Card
var card_position : Vector2

func _ready() -> void:
	card_position.x = get_window().size.x/2
	card_position.y = get_window().size.y/2
	var r = Color(1, 0, 0, 1)
	var g = Color(0, 0.4, 0, 1)
	var b = Color(0, 0, 1, 1)
	var y = Color(0.8, 0.8, 0, 1)
	colors[0] = r
	words[0] = "ROUGE"
	colors[1] = g
	words[1] = "VERT"
	colors[2] = b
	words[2] = "BLEU"
	colors[3] = y
	words[3] = "JAUNE"
	load_config()

func init(exp_type : String, script : Array, save : bool, manager : Manager) -> void:
	self.exp_type = exp_type
	self.exp_script = script
	self.save = save
	self.manager = manager

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") && once:
		timer.start(1.0)
		once = false
		label.visible = false
	
	if card == null:
		return
	
	if Input.is_action_just_pressed("ROUGE"):
		if exp_type == "find_from_color.json":
			evaluate_input_color("ROUGE")
		else:
			evaluate_input_word("ROUGE")
	elif Input.is_action_just_pressed("BLEU"):
		if exp_type == "find_from_color.json":
			evaluate_input_color("BLEU")
		else:
			evaluate_input_word("BLEU")
	elif Input.is_action_just_pressed("VERT"):
		if exp_type == "find_from_color.json":
			evaluate_input_color("VERT")
		else:
			evaluate_input_word("VERT")
	elif Input.is_action_just_pressed("JAUNE"):
		if exp_type == "find_from_color.json":
			evaluate_input_color("JAUNE")
		else:
			evaluate_input_word("JAUNE")

func evaluate_input_color(value: String) -> void:
	if value == words[exp_script[card_index][0]]:
		times.append([true, card.computeExecutionTime()])
	else:
		times.append([false, card.computeExecutionTime()])
	card.queue_free()
	card = null
	timer.start(1.0)

func evaluate_input_word(value: String) -> void:
	if value == words[exp_script[card_index][1]]:
		times.append([true, card.computeExecutionTime()])
	else:
		times.append([false, card.computeExecutionTime()])
	card.queue_free()
	card = null
	timer.start(1.0)

func save_to_json(times : Array) -> void:
	var file = FileAccess.open("res://Results/"+exp_type, FileAccess.READ)
	if file == null:
		return
	var dict = JSON.parse_string(file.get_as_text())
	dict[user_index] = times
	file.close()
	
	file = FileAccess.open("res://Results/"+exp_type, FileAccess.WRITE)
	if file == null:
		return
	var json_string = JSON.stringify(dict)
	file.store_string(json_string)
	file.close()
	if manager != null:
		manager.start_second_exp()
	if save :
		save_config()

func load_config() -> void:
	var config = ConfigFile.new()
	var err = config.load("res://data.cfg")
	if err != OK:
		user_index = 1
	else :
		var user = str(config.get_value(config.get_sections()[0], "id"))
		user_index = user.to_int()

func save_config() -> void:
	var config = ConfigFile.new()
	var err = config.load("res://data.cfg")
	if err == OK:
		config.set_value("user", "id", user_index+1)
		config.save("res://data.cfg")

func _on_timer_timeout() -> void:
	card_index += 1
	if card_index == exp_script.size():
		save_to_json(times)
		return
	
	card = scn_card.instantiate()
	card.position = Vector2(card_position)
	add_child(card)
	card.initialize(colors[exp_script[card_index][0]], words[exp_script[card_index][1]])
