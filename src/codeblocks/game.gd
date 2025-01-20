extends Node2D

@onready var buttonScene = preload("res://scenes/appButton.tscn")
@onready var windowScene = preload("res://scenes/window.tscn")
@onready var testWindowScene = preload("res://scenes/test.tscn")

# Dictionary mapping Input.CURSOR types to their corresponding textures
var cursor_textures = {
	Input.CURSOR_ARROW: preload("res://assets/cursor/cursor_arrow.png"),
	Input.CURSOR_IBEAM: preload("res://assets/cursor/cursor_ibeam.png"),
	Input.CURSOR_POINTING_HAND: preload("res://assets/cursor/cursor_pointing_hand.png"),
	Input.CURSOR_CROSS: preload("res://assets/cursor/cursor_cross.png"),
	Input.CURSOR_WAIT: preload("res://assets/cursor/cursor_wait.png"),
	Input.CURSOR_BUSY: preload("res://assets/cursor/cursor_busy.png"),
	Input.CURSOR_DRAG: preload("res://assets/cursor/cursor_drag.png"),
	Input.CURSOR_CAN_DROP: preload("res://assets/cursor/cursor_can_drop.png"),
	Input.CURSOR_FORBIDDEN: preload("res://assets/cursor/cursor_forbidden.png"),
	Input.CURSOR_VSIZE: preload("res://assets/cursor/cursor_vsize.png"),
	Input.CURSOR_HSIZE: preload("res://assets/cursor/cursor_hsize.png"),
	Input.CURSOR_BDIAGSIZE: preload("res://assets/cursor/cursor_bdiagsize.png"),
	Input.CURSOR_FDIAGSIZE: preload("res://assets/cursor/cursor_fdiagsize.png"),
	Input.CURSOR_MOVE: preload("res://assets/cursor/cursor_move.png"),
	Input.CURSOR_VSPLIT: preload("res://assets/cursor/cursor_vsplit.png"),
	Input.CURSOR_HSPLIT: preload("res://assets/cursor/cursor_hsplit.png"),
	Input.CURSOR_HELP: preload("res://assets/cursor/cursor_help.png"),
}

var previousButtonSize: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for cursor_type in cursor_textures:
		Input.set_custom_mouse_cursor(cursor_textures[cursor_type], cursor_type)
	
	create_window(testWindowScene, false, Vector2(250, 120), "test.exe")
	create_window(testWindowScene, true, Vector2(250, 120), "test.exe")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()

func add_window_to_bottom_bar(window: Node):
	if window is Control:
		var button = buttonScene.instantiate()
		button.set_controlled_window(window)
		
		button.get_child(0).get_child(0).text = window.name
		button.connect("pressed", Callable(self, "_on_window_button_pressed").bind(window, button))
		$toolbar.add_child(button)
		button.position = Vector2(2 + previousButtonSize, -6)
		previousButtonSize = button.position.x + button.get_child(0).size.x
	else:
		print("NODE %s IS IN 'window_panels' GROUP BUT IT SHOULDN'T BE", window)

func _on_window_button_pressed(window: Control, button: Control):
	button.switch_state(window)

func create_window(window_type: PackedScene, is_closeable: bool, window_pos: Vector2, window_name: String) -> Control:
	var window = window_type.instantiate()
	window.is_closeable = is_closeable
	window.position = window_pos
	window.name = window_name
	add_child(window)
	window.add_to_group("window_panels")
	
	add_window_to_bottom_bar(window)
	
	return window
	
