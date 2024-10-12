class_name Spike extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	EventBus.spiked.emit(body)
	collision_mask = 0
