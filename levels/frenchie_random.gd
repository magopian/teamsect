class_name BaseLevelRandom extends BaseLevel

@onready var obstacles: Node2D = %Obstacles


func _ready() -> void:
	randomize_children_position(obstacles)
	randomize_children_position(to_be_dangled)
	super()
	next.get_node("Label").text = "[center][wave amp=50.0 freq=5.0 connected=1]RELOAD[/wave][/center]"
	next.show()
	next.next_scene = (load(scene_file_path) as PackedScene)


func randomize_children_position(root_item: Node2D) -> void:
	var viewport_size: Vector2 = get_viewport_rect().size as Vector2
	for item in root_item.get_children():
		item.global_position.x = randf_range(100, viewport_size.x - 100)
		item.global_position.x = randf_range(100, viewport_size.x - 100)


func _on_win() -> void:
	if next.next_scene:
		next.show()
