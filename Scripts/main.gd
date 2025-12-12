extends Control

var tscn_manager: PackedScene = load("res://Scenes/manager.tscn")

func _on_color_to_word_pressed() -> void:
	var manager = tscn_manager.instantiate()
	manager.init(0)
	self.get_parent().add_child(manager)
	self.visible = false

func _on_word_to_color_pressed() -> void:
	var manager = tscn_manager.instantiate()
	manager.init(1)
	self.get_parent().add_child(manager)
	self.visible = false
