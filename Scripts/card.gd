class_name Card
extends Control

@onready var color_text : Label = $Color

var start_time
var stop_time

func initialize(color: Color, word: String) -> void:
	setColor(color)
	setWord(word)
	start_time = Time.get_unix_time_from_system()

func computeExecutionTime() -> float:
	stop_time = Time.get_unix_time_from_system()
	var exec_time = stop_time - start_time
	exec_time = floor(exec_time * 100)
	return exec_time/100

func setColor(color: Color)->void:
	color_text.add_theme_color_override("font_color", color)
	
func setWord(word: String)->void:
	color_text.text = word
