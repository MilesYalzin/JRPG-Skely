extends Control
class_name Confirm

@onready var buttons: Array = [$VBoxContainer/HBoxContainer/YES,$VBoxContainer/HBoxContainer/NO]
@onready var label = $VBoxContainer/label
var selected_index: int = 0
var prev 
@onready var cursor = $Cursor

signal confirmed
signal cancelled

static func spawnConfirm(text : String, parent, _prev):
	var new = preload("res://UI/confirmMenu.tscn").instantiate()
	new.prev = _prev
	parent.add_child(new)
	new.label.text = text

	
	return new

func _ready() -> void:
	update_cursor_position()
	prev.set_process(false)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("down"):
		selected_index = (selected_index + 1) % buttons.size()
		update_cursor_position()
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("up"):
		selected_index = (selected_index - 1 + buttons.size()) % buttons.size()
		update_cursor_position()
	elif Input.is_action_just_pressed("accept"):
		_on_button_pressed(buttons[selected_index])
	elif Input.is_action_just_pressed("cancel"):
		queue_free()
		prev.set_process(true)

func update_cursor_position():
		var button = buttons[selected_index]
		cursor.global_position = button.global_position - Vector2(30, 0)
		
func _on_button_pressed(button):
	if button.name == "YES":
		emit_signal("confirmed")
		queue_free()
		prev.set_process(true)
	else:
		emit_signal("cancelled")
		queue_free()
		prev.set_process(true)
