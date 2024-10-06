extends Area2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var win_here: Sprite2D = %WinHere

@export var next_target: RigidBody2D
@export var current_target: bool = false
@export var accepts: RigidBody2D
	

func _process(_delta: float) -> void:
	win_here.visible = current_target
	if current_target:
		animation_player.play("glow")
	else:
		animation_player.play("RESET")


func _on_body_entered(body: Node2D) -> void:
	if body == accepts:
		animation_player.play("RESET")
		win_here.hide()
		EventBus.target_reached.emit(body)
		if not next_target:
			EventBus.win.emit()
