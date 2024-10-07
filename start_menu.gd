extends Node2D


func _on_texture_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://levels/blood_drop.tscn")


func _on_reload_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://levels/frenchie_random.tscn")


func _on_credits_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://credits.tscn")
