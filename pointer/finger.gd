class_name Finger extends RigidBody2D

@onready var anchor: Marker2D = $anchor
@onready var sprite_size: Vector2


func _ready() -> void:
	var sprite: Sprite2D = get_node("Sprite2D")
	sprite_size = sprite.texture.get_size()
	set_mouse_position()


func get_anchor_position() -> Vector2:
	return anchor.global_position

func _physics_process(_delta: float) -> void:
	set_mouse_position()


func set_mouse_position() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var mouse_position: Vector2 = get_global_mouse_position()
	var viewport_size: Vector2 = get_viewport_rect().size as Vector2
	mouse_position.x = clamp(mouse_position.x, sprite_size.x / 2, viewport_size.x - (sprite_size.x/2))
	mouse_position.y = clamp(mouse_position.y, sprite_size.y / 2, viewport_size.y - 20)
	position = mouse_position
