extends Control
class_name MenuClass

var options: Array = []
var selectedIndex = 0
@onready var buttonList: Container = $buttonList
@onready var cursor: Cursor = $Cursor
	
func setup(_options: Array, fill: bool = false) -> void:
	options = _options
	updateMenu(fill)
	cursor.linkTo(self)
	
func updateMenu(fill = false):
	clearMenu(buttonList)
	for option in options:
		var btn = Button.new()
		
		if fill: 
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		if option is Dictionary:
			btn.text = str(option.get("text"))
			if not option.get("enabled", true):
				btn.modulate = Color(0.6, 0.6, 0.6)
		else:
			btn.text = str(option)
		btn.focus_mode = Control.FOCUS_NONE
		buttonList.add_child(btn)
		
	call_deferred("updateCursor")

func clearMenu(node):
	for child in node.get_children():
		child.queue_free()
		

func get_button(index: int) -> Control:
	return buttonList.get_child(index)

func get_count() -> int:
	return buttonList.get_child_count()
	
func updateCursor():
	cursor.updatePosition()
