extends RigidBody2D

@onready var animation_player: AnimationPlayer
@onready var win_here: Sprite2D
@onready var child: CollisionShape2D

@export var next_target: RigidBody2D
@export var current_target: bool = false
@export var accepts: RigidBody2D

func _ready() -> void:
	print("children: ", get_children())
	child = get_child(0)
	print("child: ", child)
	animation_player = child.find_child("AnimationPlayer")
	win_here = child.find_child("WinHere")
	body_entered.connect(_on_body_entered)
	

func _process(_delta: float) -> void:
	win_here.visible = current_target
	if current_target:
		animation_player.play("glow")
	else:
		animation_player.play("RESET")


func _on_body_entered(body: Node2D) -> void:
	if body == accepts:
		collision_mask = 0
		set_deferred("contact_monitor", false)
		EventBus.new_dangling.emit(body, self)
		set_deferred("gravity_scale", 8)
		animation_player.play("RESET")
		win_here.hide()
		EventBus.target_reached.emit(body)
		if not next_target:
			EventBus.win.emit()
