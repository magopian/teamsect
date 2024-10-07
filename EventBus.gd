extends Node


signal pricked
signal new_dangling(dangling_node: RigidBody2D)
signal target_reached(target: RigidBody2D, body: RigidBody2D)
signal win
signal next
signal spiked(body: RigidBody2D)

@export var nightmare_level = 0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://start_menu.tscn")
