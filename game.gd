extends Node2D

@onready var finger: RigidBody2D = %Finger
@onready var dangling: Node2D = %Dangling
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var joint_scene: PackedScene = preload("res://dangling/joint.tscn")
@onready var blood_scene: PackedScene = preload("res://dangling/blood_drop.tscn")
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

@export var aie_sounds: Array[AudioStream]
@export var ahh_sounds: Array[AudioStream]


func _ready() -> void:
	setup_dangling()
	EventBus.new_dangling.connect(add_dangling)
	EventBus.pricked.connect(_on_pricked)
	EventBus.blood_fixed.connect(_on_blood_fixed)


func add_dangling(body: RigidBody2D) -> void:
	body.reparent(dangling)
	setup_dangling()


func setup_dangling() -> void:
	var dangling_children: Array[Node] = dangling.get_children()
	print("dangling children: ", dangling_children)
	var current_anchor: RigidBody2D = finger
	for child in dangling_children:
		var joint: PinJoint2D = joint_scene.instantiate()
		joint.join_nodes(current_anchor, child)
		add_child(joint)
		current_anchor = child
		
func _on_pricked() -> void:
	var aie: AudioStream = aie_sounds.pick_random()
	audio_stream_player.stream = aie
	audio_stream_player.play()
	animation_player.play("pricked")
	
func _on_blood_fixed(_body: RigidBody2D) -> void:
	var ahh: AudioStream = ahh_sounds.pick_random()
	audio_stream_player.stream = ahh
	audio_stream_player.play()
	animation_player.play_backwards("pricked")
