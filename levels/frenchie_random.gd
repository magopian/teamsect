class_name BaseLevelRandom extends BaseLevel

@onready var obstacles: Node2D = %Obstacles
@onready var nightmare_level: HSlider = %NightmareLevel
@onready var nightmare_level_label: Label = %NightmareLevelLabel
@onready var spikes: Node2D = %Spikes
@onready var spike_scene: PackedScene = preload("res://obstacles/spikes.tscn")


func _ready() -> void:
	nightmare_level.value = EventBus.nightmare_level
	generate_spikes()
	randomize_children_position(obstacles)
	randomize_children_position(to_be_dangled)
	super()
	var next_label: RichTextLabel = next.get_node("%Label")
	next_label.text = "[center][wave amp=50.0 freq=5.0 connected=1]RELOAD[/wave][/center]"
	next_label.add_theme_font_size_override("normal_font_size", 42)
	
	next.show()
	next.next_scene = (load(scene_file_path) as PackedScene)

func randomize_children_position(root_item: Node2D) -> void:
	var viewport_size: Vector2 = get_viewport_rect().size as Vector2
	for item in root_item.get_children():
		item.global_position.x = randf_range(100, viewport_size.x - 100)
		item.global_position.y = randf_range(100, viewport_size.y - 100)


func _on_win() -> void:
	next.hide()
	you_win.show()


func _on_h_slider_value_changed(value: float) -> void:
	EventBus.nightmare_level = value
	nightmare_level_label.text = str(value)
	generate_spikes()


func generate_spikes() -> void:
	for spike in spikes.get_children():
		spike.queue_free()
	for _i in range(nightmare_level.value):
		var spike: Spike = spike_scene.instantiate()
		spikes.add_child(spike)
	randomize_children_position(spikes)


func _on_reload_button_pressed() -> void:
	# This button is only available in the random levels
	await get_tree().create_timer(0.1).timeout
	get_tree().reload_current_scene()
