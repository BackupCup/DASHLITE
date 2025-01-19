extends Node2D

@onready var buttonScene = preload("res://scenes/appButton.tscn")

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
	for window in get_tree().get_nodes_in_group("window_panels"):
		add_window_to_bottom_bar(window)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_window_to_bottom_bar(window: Node):
	if window is Control:
		var button = buttonScene.instantiate()
		
		button.get_child(0).get_child(0).text = window.name
		button.connect("pressed", Callable(self, "_on_window_button_pressed").bind(window, button))
		$toolbar.add_child(button)
		button.position = Vector2(2 + previousButtonSize, -6)
		previousButtonSize = button.position.x + button.get_child(0).size.x
	else:
		print("NODE %s IS IN 'window_panels' GROUP BUT IT SHOULDN'T BE", window)

func _on_window_button_pressed(window: Control, button: Control):
	if (window.visible):
		window.hide()
		button.switch_state()
	else:
		var original_z_index = window.z_index
		window.decrement_windows_z_index(window)
		window.z_index = window.get_max_z_index() + 1
		
		window.show()
		button.switch_state()
