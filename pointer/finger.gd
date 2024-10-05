class_name Finger extends RigidBody2D

@onready var anchor: Marker2D = $anchor


func _ready() -> void:
	EventBus.pricked.connect(_on_pricked)


func get_anchor_position() -> Vector2:
	return anchor.global_position

func _physics_process(_delta: float) -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var mouse_position: Vector2 = get_global_mouse_position()
	position = mouse_position


func _on_pricked() -> void:
	print("pricked !!")
