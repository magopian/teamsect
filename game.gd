extends Node2D

@onready var finger: RigidBody2D = %Finger
@onready var dangling: Node2D = %Dangling
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var joint_scene: PackedScene = preload("res://dangling/joint.tscn")
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var camera_shaker: Node2D = %CameraShaker
@onready var win_here: Sprite2D = %WinHere
@onready var next: Node2D = %Next
@onready var bandaid: RigidBody2D = %Bandaid
@onready var blood_drop: RigidBody2D = %"Blood drop"

@export var aie_sounds: Array[AudioStream]
@export var ahh_sounds: Array[AudioStream]


func _ready() -> void:
	setup_dangling()
	EventBus.new_dangling.connect(add_dangling)
	EventBus.pricked.connect(_on_pricked)
	EventBus.target_reached.connect(_on_target_reached)
	EventBus.win.connect(_on_win)
	EventBus.next.connect(_on_next)


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
		add_child(joint)
		joint.join_nodes(current_node, child)
		current_node = child


func _on_pricked() -> void:
	var aie: AudioStream = aie_sounds.pick_random()
	audio_stream_player.stream = aie
	audio_stream_player.play()
	animation_player.play("pricked")
	win_here.hide()
	camera_shaker.apply_shake(10, 5)
	bandaid.current_target = true
	
func _on_target_reached(target: RigidBody2D, body: RigidBody2D) -> void:
	var ahh: AudioStream = ahh_sounds.pick_random()
	audio_stream_player.stream = ahh
	audio_stream_player.play()
	target.current_target = false
	if target.next_target:
		target.next_target.current_target = true
	
	
func _on_win() -> void:
	if next.next_scene:
		next.show()
	

func _on_next() -> void:
	print("next!!")
