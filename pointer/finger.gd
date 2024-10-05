class_name Finger extends RigidBody2D

@onready var anchor: Marker2D = $anchor
@onready var sprite_size: Vector2


func _ready() -> void:
	var sprite: Sprite2D = get_node("Sprite2D")
	sprite_size = sprite.texture.get_size()
	EventBus.pricked.connect(_on_pricked)


func get_anchor_position() -> Vector2:
	return anchor.global_position

func _physics_process(_delta: float) -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var mouse_position: Vector2 = get_global_mouse_position()
	var window_size: Vector2 = get_window().size as Vector2
	mouse_position.x = clamp(mouse_position.x, sprite_size.x / 2, window_size.x - (sprite_size.x/2))
	mouse_position.y = clamp(mouse_position.y, sprite_size.y / 2, window_size.y - (sprite_size.y / 2))
	position = mouse_position


func _on_pricked() -> void:
	print("pricked !!")
