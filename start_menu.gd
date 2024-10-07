extends Node2D


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/blood_drop.tscn")


func _on_reload_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/frenchie_random.tscn")
