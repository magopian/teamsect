class_name Spike extends Area2D


func _on_body_entered(body: Node2D) -> void:
	EventBus.spiked.emit(body)
	collision_mask = 0
