extends Node


signal pricked
signal new_dangling(dangling_node: RigidBody2D)
signal target_reached(target: RigidBody2D, body: RigidBody2D)
signal win
signal next


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
