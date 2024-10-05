extends Area2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var win_here: Sprite2D = %WinHere


func _ready() -> void:
	EventBus.pricked.connect(_on_pricked)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Blood drop":
		animation_player.play("RESET")
		win_here.hide()
		EventBus.blood_fixed.emit(body)


func _on_pricked() -> void:
	animation_player.play("glow")
	win_here.show()
