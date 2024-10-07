class_name Dangling extends RigidBody2D

@onready var win_here: Sprite2D = %WinHere
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

@export var next_target: RigidBody2D
@export var current_target: bool = false
@export var accepts: RigidBody2D
@export var ahh_sounds: Array[AudioStream]


func _ready() -> void:
	win_here.hide()
	body_entered.connect(_on_body_entered)
	

func _process(_delta: float) -> void:
	if not is_inside_tree():
		return
	win_here.visible = current_target


func _on_body_entered(body: Node2D) -> void:
	if body == accepts:
		play_random_sound(ahh_sounds)
		collision_mask = 0
		set_deferred("contact_monitor", false)
		EventBus.new_dangling.emit(self)
		set_deferred("gravity_scale", 8)
		win_here.hide()
		EventBus.target_reached.emit(self, body)
		if not next_target:
			EventBus.win.emit()


func play_random_sound(sounds: Array[AudioStream]) -> void:
	if not sounds:
		return
	var aie: AudioStream = sounds.pick_random()
	audio_stream_player.stream = aie
	audio_stream_player.play()
