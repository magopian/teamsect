class_name Dangling extends RigidBody2D

@onready var win_here: Sprite2D = %WinHere
@onready var audio_stream_player: AudioStreamPlayer

@export var next_target: RigidBody2D
@export var current_target: bool = false
@export var accepts: RigidBody2D


func _ready() -> void:
	audio_stream_player = get_node_or_null("%AudioStreamPlayer")
	win_here.hide()
	body_entered.connect(_on_body_entered)
	set_collision_mask_value(16, true)


func _process(_delta: float) -> void:
	if not is_inside_tree() or name == "Blood drop":
		# Blood drop is managed differently.
		return
	win_here.visible = current_target


func _on_body_entered(body: Node2D) -> void:
	if body == accepts and body.get_parent().name == "Dangling":
		if audio_stream_player:  # The blood drop doesn't have its own audio stream player
			audio_stream_player.play()
		collision_mask = 0
		set_collision_mask_value(16, true)
		set_deferred("contact_monitor", false)
		EventBus.new_dangling.emit(self)
		set_deferred("gravity_scale", 8)
		win_here.hide()
		EventBus.target_reached.emit(self, body)
		if not next_target:
			EventBus.win.emit()
