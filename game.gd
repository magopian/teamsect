extends Node2D

@onready var finger: RigidBody2D = %Finger
@onready var dangling: Node2D = %Dangling
@onready var joint_scene: PackedScene = preload("res://dangling/joint.tscn")


func _ready() -> void:
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
