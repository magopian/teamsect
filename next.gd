extends Node2D

@export var next_scene: PackedScene

func _on_button_pressed() -> void:
	EventBus.next.emit()
	await get_tree().create_timer(0.1).timeout
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
