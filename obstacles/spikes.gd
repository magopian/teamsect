class_name Spike extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	EventBus.spiked.emit(body)
	collision_mask = 0
