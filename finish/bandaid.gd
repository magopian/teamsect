extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Blood drop":
		EventBus.blood_fixed.emit(body)
