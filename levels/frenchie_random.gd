class_name BaseLevelRandom extends BaseLevel

@onready var obstacles: Node2D = %Obstacles
@onready var nightmare_level: HSlider = %NightmareLevel
@onready var nightmare_level_label: Label = %NightmareLevelLabel
@onready var spawn_exclude_zone: Polygon2D = %SpawnExcludeZone
@onready var spikes: Node2D = %Spikes

@onready var spike_scene: PackedScene = preload("res://obstacles/spikes.tscn")

var polygon_points:  PackedVector2Array
var spawn_points: Array[Vector2]

const DANGLING_SIZE: int = 200

func _ready() -> void:
	generate_spawn_points()
	nightmare_level.value = EventBus.nightmare_level
	randomize_children_position(obstacles)
	randomize_children_position(to_be_dangled)
	super()


func generate_spawn_points() -> void:
	polygon_points = spawn_exclude_zone.polygon
	var viewport_size: Vector2 = get_viewport_rect().size as Vector2
	var point: Vector2
	for x in (viewport_size.x / DANGLING_SIZE):
		for y in (viewport_size.y / DANGLING_SIZE):
			point = Vector2(x * DANGLING_SIZE, y * DANGLING_SIZE)
			if not Geometry2D.is_point_in_polygon(point, polygon_points):
				spawn_points.append(point)


func randomize_children_position(root_item: Node2D) -> void:
	for item in root_item.get_children():
		# -1 because it's an inclusive range, and -1 because the array is 0-indexed.
		var i: int = randi_range(0, spawn_points.size() - 1 -1)
		var item_position = spawn_points.pop_at(i)
		item.global_position = item_position


func _on_win() -> void:
	next.hide()
	you_win.show()


func _on_h_slider_value_changed(value: float) -> void:
	EventBus.nightmare_level = value
	nightmare_level_label.text = str(value)
	generate_spikes()


func generate_spikes() -> void:
	for spike in spikes.get_children():
		# We're also freeing the spawn points.
		spawn_points.append(spike.global_position)
		spikes.remove_child(spike)
		spike.queue_free()
	for _i in range(nightmare_level.value):
		var spike: Spike = spike_scene.instantiate()
		spikes.add_child(spike)
	randomize_children_position(spikes)


func _on_reload_button_pressed() -> void:
	# This button is only available in the random levels
	await get_tree().create_timer(0.1).timeout
	get_tree().reload_current_scene()


func _on_random_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().reload_current_scene()
