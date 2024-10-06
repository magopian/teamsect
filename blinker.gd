extends Node2D


@onready var target: Node2D

func _ready() -> void:
	if not is_inside_tree():
		return
	target = get_parent()
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	tween.set_loops()  # Loop indefinitely
	tween.tween_property(target, "modulate:a", 0, 0.25)
	tween.tween_property(target, "modulate:a", 1, 0.25)
	tween.tween_interval(0.5)
