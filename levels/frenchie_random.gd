class_name BaseLevelRandom extends BaseLevel

@onready var obstacles: Node2D = %Obstacles
@onready var nightmare_level: HSlider = %NightmareLevel
@onready var nightmare_level_label: Label = %NightmareLevelLabel
@onready var spawn_exclude_zone: Polygon2D = %SpawnExcludeZone
@onready var spikes: Node2D = %Spikes

@onready var spike_scene: PackedScene = preload("res://obstacles/spikes.tscn")

var polygon_points:  PackedVector2Array
var spawn_points: Array[Vector2]
var saved_scene: PackedScene = PackedScene.new()

const DANGLING_SIZE: int = 200

func _ready() -> void:
	nightmare_level.value_changed.connect(_on_nightmare_level_changed)
	nightmare_level_label.text = str(EventBus.nightmare_level)
	generate_spawn_points()
	if not is_restarted():
		nightmare_level.value = EventBus.nightmare_level
		randomize_children_position(obstacles)
		randomize_children_position(to_be_dangled)
		generate_spikes()
		set_restarted()
	else:
		# We've restarted from a saved packed scene, don't do any setup.
		print("we've restarted!")
		# TODO: remove spawn points already taken
	super()
	saved_scene.pack(self)


func set_restarted() -> void:
	var restarted: Node = Node.new()
	restarted.name = "restarted"
	add_child(restarted)
	restarted.owner = self


func is_restarted() -> Node:
	return find_child("restarted")


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


func _on_pricked() -> void:
	if not is_inside_tree():
		return
	if pricked:
		print("restarting")
		return get_tree().call_deferred("change_scene_to_packed", saved_scene)
	prick()


func _on_win() -> void:
	next.hide()
	you_win.show()
	Music.play_win()


func _on_nightmare_level_changed(value: float) -> void:
	if EventBus.nightmare_level == value:
		return
	print("nightmare level changed! ", nightmare_level.value)
	EventBus.nightmare_level = value
	get_tree().change_scene_to_file("res://levels/frenchie_random.tscn")


func generate_spikes() -> void:
	for spike in spikes.get_children():
		# We're also freeing the spawn points.
		spawn_points.append(spike.global_position)
		spikes.remove_child(spike)
		spike.queue_free()
	for _i in range(nightmare_level.value):
		var spike: Spike = spike_scene.instantiate()
		spikes.add_child(spike)
		spike.owner = self
	saved_scene.pack(self)
	randomize_children_position(spikes)


func _on_random_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://levels/frenchie_random.tscn")
