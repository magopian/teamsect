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
	add_dangling(finger, blood_drop)
	EventBus.new_dangling.connect(add_dangling)
	EventBus.pricked.connect(_on_pricked)
	EventBus.target_reached.connect(_on_blood_fixed)
	EventBus.win.connect(_on_win)
	EventBus.next.connect(_on_next)


func add_dangling(anchor_node: RigidBody2D, dangling_node: RigidBody2D) -> void:
	var joint: PinJoint2D = joint_scene.instantiate()
	joint.join_nodes(anchor_node, dangling_node)
	add_child(joint)
		
func _on_pricked() -> void:
	var aie: AudioStream = aie_sounds.pick_random()
	audio_stream_player.stream = aie
	audio_stream_player.play()
	animation_player.play("pricked")
	win_here.hide()
	camera_shaker.apply_shake(10, 5)
	bandaid.current_target = true
	
func _on_blood_fixed(_body: RigidBody2D) -> void:
	var ahh: AudioStream = ahh_sounds.pick_random()
	audio_stream_player.stream = ahh
	audio_stream_player.play()
	win_here.show()
	bandaid.current_target = false
	
	
func _on_win() -> void:
	next.show()
	

func _on_next() -> void:
	print("next!!")
