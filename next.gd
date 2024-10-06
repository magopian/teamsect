extends Node2D


func _on_button_pressed() -> void:
	EventBus.next.emit()
