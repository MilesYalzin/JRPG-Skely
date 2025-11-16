extends Control
class_name MenuClass

var options: Array = []
var selectedIndex = 0
@onready var buttonList: Container = $buttonList
@onready var cursor: Cursor = $Cursor
	
func setup(_options: Array, fill: bool = false) -> void:
	options = _options
	cursor.setActive(true)
	updateMenu(fill)
	
func updateMenu(fill = false):
	clearMenu(buttonList)
	if buttonList is HBoxContainer:
		cursor.axis = Cursor.CursorAxis.X
	elif buttonList is VBoxContainer:
		cursor.axis = Cursor.CursorAxis.Y
	for option in options:
		var btn = Button.new()
		
		if fill: 
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		if option is Dictionary:
			btn.text = str(option.get("text"))
			if not option.get("enabled", true):
				btn.modulate = Color(0.6, 0.6, 0.6)
			cursor.addOption(btn, option.get("confirm", option.get("action")), option.get("scrollover"))
		else:
			btn.text = str(option)
		btn.focus_mode = Control.FOCUS_NONE
		buttonList.add_child(btn)
	cursor.call_deferred("updatePosition")

func clearMenu(node):
	for child in node.get_children():
		child.queue_free()
