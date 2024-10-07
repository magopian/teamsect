class_name BaseLevel extends Node2D

@onready var finger: RigidBody2D = %Finger
@onready var dangling: Node2D = %Dangling
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var joint_scene: PackedScene = preload("res://dangling/joint.tscn")
@onready var camera_shaker: Node2D = %CameraShaker
@onready var win_here: Sprite2D = %WinHere
@onready var next: Node2D = %Next
@onready var bandaid: Dangling = %Bandaid
@onready var blood_drop: Dangling = %"Blood drop"
@onready var restart_label: RichTextLabel = %RestartLabel
@onready var to_be_dangled: Node2D = %ToBeDangled
@onready var you_win: Node2D = %YouWin
@onready var ahh_audio_stream_player: AudioStreamPlayer = %AhhAudioStreamPlayer
@onready var aie_audio_stream_player: AudioStreamPlayer = %AieAudioStreamPlayer
@onready var oh_no_audio_stream_player: AudioStreamPlayer = %OhNoAudioStreamPlayer
@onready var joints: Node2D = %Joints

@export var explode_velocity: int = 3500


func _ready() -> void:
	setup_dangling()
	EventBus.new_dangling.connect(add_dangling)
	EventBus.pricked.connect(_on_pricked)
	EventBus.target_reached.connect(_on_target_reached)
	EventBus.win.connect(_on_win)
	EventBus.spiked.connect(_on_spiked)
	restart_label.hide()
	next.hide()
	you_win.hide()
	win_here.show()
	setup_accept_next()


func setup_accept_next() -> void:
	var children: Array[Node] = to_be_dangled.get_children()
	var index: int = 0
	var num_children: int = children.size()
	var prev_dangling: Dangling = blood_drop
	for child in (children as Array[Dangling]):
		index += 1
		child.accepts = prev_dangling
		if index < num_children:  # Not for the last child
			child.next_target = children[index]
		prev_dangling = child


func add_dangling(dangling_node: RigidBody2D) -> void:
	dangling_node.call_deferred("reparent", dangling)
	call_deferred("setup_dangling")

func setup_dangling() -> void:
	var current_node: RigidBody2D = finger
	var children: Array[Node] = dangling.get_children()
	for child in children:
		dangling.remove_child(child)
	for child in children:
		var joint: PinJoint2D = joint_scene.instantiate()
		dangling.add_child(child)
		joints.add_child(joint)
		joint.join_nodes(current_node, child)
		current_node = child


func _on_pricked() -> void:
	if not is_inside_tree():
		return
	if dangling.get_children().size() > 1:
		get_tree().reload_current_scene()
	aie_audio_stream_player.play()
	animation_player.play("pricked")
	win_here.hide()
	camera_shaker.apply_shake(10, 5)
	bandaid.current_target = true
	restart_label.show()

func _on_target_reached(target: RigidBody2D, body: RigidBody2D) -> void:
	if body.name == "Blood drop":
		ahh_audio_stream_player.play()
	target.current_target = false
	if target.next_target:
		target.next_target.current_target = true
	
	
func _on_win() -> void:
	if next.next_scene:
		next.show()
	else:
		you_win.show()
		Music.play_win()


func _on_spiked(body: RigidBody2D) -> void:
	oh_no_audio_stream_player.play()
	camera_shaker.apply_shake(10, 5)
	Engine.time_scale = 0.1
	await get_tree().create_timer(1, true, false, true).timeout
	Engine.time_scale = 1
	explode_dangling()
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()


func explode_dangling() -> void:
	for joint in joints.get_children():
		joint.queue_free()
	for child in (dangling.get_children() as Array[RigidBody2D]):
		child.linear_velocity = Vector2.from_angle(randi_range(-180, 180)) * explode_velocity
		print(child.linear_velocity, " ", child.rotation_degrees)

func _on_reload_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://levels/frenchie_random.tscn")
