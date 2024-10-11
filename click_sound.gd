extends AudioStreamPlayer

@export var down_click: AudioStream
@export var up_click: AudioStream

func _ready() -> void:
	var parent: Control = get_parent()
	parent.button_down.connect(_on_button_down)
	parent.button_up.connect(_on_button_up)


func _on_button_down() -> void:
	if is_inside_tree():
		stream = down_click
		play()
		
func _on_button_up() -> void:
	if is_inside_tree():
		stream = up_click
		play()
