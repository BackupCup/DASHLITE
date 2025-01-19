extends TextureButton

@onready var textureNode = $Texture
@onready var textNode = $Texture/Text

const letter_width: int = 5
const wideLetterList = ['#', '@', 'm', 'n', 'v', 'w', 'x']

var paddingStart: int = 2
var paddingEnd: int = 2

var isWindowVisible = false

func _ready():
	textNode.mouse_filter = Control.MOUSE_FILTER_IGNORE
	update_texture_size()
	switch_state()

func get_text_padding() -> Vector2:
	if textNode.text.length() <= 0:
		return Vector2(0, 0)
	
	var textPaddingStart = 0
	var textPaddingEnd = 4
	
	if wideLetterList.find(textNode.text[0].to_lower()) != -1:
		textPaddingStart = 1
		textPaddingEnd += 1
	
	if wideLetterList.find(textNode.text[-1].to_lower()) != -1:
		textPaddingEnd += 2
	
	return Vector2(textPaddingStart, textPaddingEnd)

func update_texture_size():
	var text_width = textNode.text.length() * letter_width + get_text_padding().y
	textNode.set_size(Vector2(text_width, 5))
	textNode.position = Vector2(3, 3)
	set_size(Vector2(text_width, 13))

func switch_state():
	if isWindowVisible:
		isWindowVisible = false
		size.y -= 8
		position.y += 8
		textNode.position.y -= 8
	else:
		isWindowVisible = true
		size.y += 8
		position.y -= 8
		textNode.position.y += 8
		
	
