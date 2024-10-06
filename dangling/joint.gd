extends PinJoint2D


func join_nodes(anchor_node: RigidBody2D, dangling_node: RigidBody2D) -> void:
	anchor_node.global_rotation = 0
	var anchor_position = get_anchor_position(anchor_node)
	dangling_node.global_rotation = 0
	dangling_node.global_position = anchor_position
	global_position = anchor_position
	node_a = anchor_node.get_path()
	node_b = dangling_node.get_path()


func get_anchor_position(node: RigidBody2D) -> Vector2:
	var anchor: Marker2D = node.find_child("anchor")
	return anchor.global_position
