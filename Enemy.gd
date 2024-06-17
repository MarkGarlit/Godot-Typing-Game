extends Sprite2D

@export var blue = Color()
@export var green = Color()
@export var red = Color()

@export var speed = randf_range(1, 2) * 1


@onready var prompt = $RichTextLabel
@onready var prompt_text = prompt.text


func _physics_process(delta: float) -> void:
	global_position.x -= speed

func get_prompt() -> String:
	return prompt_text

func set_next_character(next_character_index: int):
	var blue_text = get_bbcode_color_tag(blue) + prompt_text.substr(0,next_character_index) + get_bbcode_end_color_tag() + " "
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(next_character_index,1) + get_bbcode_end_color_tag()
	var red_text = ""
	if next_character_index != prompt_text.length():
		red_text = get_bbcode_color_tag(red) + prompt_text.substr(next_character_index + 1, prompt_text.length() - next_character_index + 1) + get_bbcode_end_color_tag()
	prompt.parse_bbcode(blue_text + green_text + red_text)
	
func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" +color.to_html(false) + "]"
	
func get_bbcode_end_color_tag() -> String:
	return "[/color]"
