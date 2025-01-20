extends Node2D

const letter_width: int = 5
const wideLetterList = ['#', '@', 'm', 'n', 'v', 'w', 'x']
const sizeMap = {
	preload("res://assets/button/button_ends.png"): Vector2(2, 1),
	preload("res://assets/button/button_statement.png"): Vector2(3, 3),
	preload("res://assets/button/button_condition.png"): Vector2(3, 3),
	preload("res://assets/button/button_operand.png"): Vector2(5, 7),
	preload("res://assets/button/button_set.png"): Vector2(5, 5),
	preload("res://assets/button/button_fail.png"): Vector2(4, 3),
	preload("res://assets/button/button_success.png"): Vector2(4, 3)
}

@export var blockText: String = "stop"
@export var blockTexture: Texture2D = preload("res://assets/button/button_ends.png")

var paddingStart: int = 2
var paddingEnd: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	paddingStart = sizeMap[blockTexture].x
	paddingEnd = sizeMap[blockTexture].y
	update_texture_size()

func get_text_padding() -> Vector2:
	if $Text.text.length() <= 0:
		return Vector2(0, 0)
	
	var textPaddingStart = 0
	var textPaddingEnd = 1
	
	if wideLetterList.find($Text.text[0].to_lower()) != -1:
		textPaddingStart = 0
		textPaddingEnd += 1
	
	if wideLetterList.find($Text.text[-1].to_lower()) != -1:
		textPaddingEnd += 1
	
	return Vector2(textPaddingStart, textPaddingEnd)

func update_texture_size():
	$Texture.texture = blockTexture
	$Texture.patch_margin_left = paddingStart
	$Texture.patch_margin_right = paddingEnd
	
	$Text.text = blockText
	
	$Text.position.x += paddingStart + get_text_padding().x
	
	var text_width = $Text.text.length() * letter_width + paddingEnd + get_text_padding().y
	$Text.set_size(Vector2(text_width, $Text.size.y))
	
	$Texture.set_size(Vector2(text_width, $Texture.size.y))
