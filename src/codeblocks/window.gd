extends Control

@export var is_closeable: bool = true

const letter_width: int = 5
const wideLetterList = ['#', '@', 'm', 'n', 'v', 'w', 'x']

var dragging = false
var drag_offset: Vector2
var dragged_window = null
var original_z_index = -1

func _ready():
	if is_closeable:
		$GridContainer/Texture.texture = preload("res://assets/ui/window.png")
	else:
		$GridContainer/Texture.texture = preload("res://assets/ui/window_uncloseable.png")
	
	$GridContainer/Texture/Text.text = name
	var textSize = get_text_padding().y + $GridContainer/Texture/Text.text.length() * letter_width
	$GridContainer/Texture/Text.size.x = textSize
	$GridContainer/Texture/Text.position.x += get_text_padding().x
	$GridContainer.size.x = textSize + 35

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		var window_size = get_viewport().get_visible_rect().size / get_tree().root.get_node("Game").get_node("Camera2D").zoom
		var new_position = lerp(dragged_window.position, get_global_mouse_position() + drag_offset, 0.25)
		
		new_position.x = clamp(new_position.x, 0, window_size.x - $GridContainer/Texture.size.x)
		new_position.y = clamp(new_position.y, 0, window_size.y - 29)
		
		dragged_window.position = new_position

func _input(event):
	var mouse_pos = get_global_mouse_position()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var top_window = get_topmost_window(mouse_pos)
				if top_window == self and is_mouse_over():
					dragging = true
					dragged_window = self
					if dragged_window != null:
						original_z_index = dragged_window.z_index
						decrement_windows_z_index(dragged_window)
						dragged_window.z_index = get_max_z_index() + 1
						drag_offset = position - mouse_pos
			else:
				dragging = false
				dragged_window = null

func is_mouse_over() -> bool:
	var texture_rect = Rect2(position.x, position.y, $GridContainer/Texture.size.x, 13.0)
	return texture_rect.has_point(get_global_mouse_position())

func get_topmost_window(mouse_pos: Vector2) -> Control:
	var windows = get_tree().root.get_node("Game").get_children()
	var top_window: Control = null
	var highest_z_index = -25
	for window in windows:
		# Check if the window is under the mouse cursor and has a higher z_index
		if window is Control and Rect2(window.position, window.get_child(0).get_child(0).size).has_point(mouse_pos):
			if window.z_index > highest_z_index:
				highest_z_index = window.z_index
				top_window = window

	return top_window

func decrement_windows_z_index(excluded_window: Control):
	if get_tree() == null:
		return
	
	var windows = get_tree().root.get_node("Game").get_children()
	for window in windows:
		if window is Control and window != excluded_window:
			window.z_index -= 1

func get_max_z_index() -> int:
	if get_tree() == null:
		return 1
	
	var windows = get_tree().root.get_node("Game").get_children()
	var max_z_index = -25
	for window in windows:
		if window is Control:
			if window != dragged_window:
				max_z_index = max(max_z_index, window.z_index)
	return max_z_index

func get_text_padding() -> Vector2:
	if $GridContainer/Texture/Text.text.length() <= 0:
		return Vector2(0, 0)
	
	var textPaddingStart = 0
	var textPaddingEnd = 0
	
	if wideLetterList.find($GridContainer/Texture/Text.text[0].to_lower()) != -1:
		textPaddingStart = 1
		textPaddingEnd += 1
	
	if wideLetterList.find($GridContainer/Texture/Text.text[-1].to_lower()) != -1:
		textPaddingEnd += 1
	
	return Vector2(textPaddingStart, textPaddingEnd)
