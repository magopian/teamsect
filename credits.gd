extends Node2D


func _on_credits_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://start_menu.tscn")
