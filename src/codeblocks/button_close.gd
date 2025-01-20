extends TextureButton

var linkedButton = null
var linkedWindow = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _pressed():
	linkedButton.switch_state(linkedWindow)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
