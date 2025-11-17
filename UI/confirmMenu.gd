extends Control
class_name Confirm

@onready var buttons: Array = [$VBoxContainer/HBoxContainer/YES,$VBoxContainer/HBoxContainer/NO]
@onready var label = $VBoxContainer/label
@onready var cursor = $Cursor

signal confirmed
signal cancelled

static func spawnConfirm(text : String, parent) -> Confirm:
	var conf: Confirm = preload("res://UI/confirmMenu.tscn").instantiate()
	parent.add_child(conf)
	conf.label.text = text
	return conf
	
func _ready():
	confirmed.connect(queue_free)
	cancelled.connect(queue_free)
	cursor.addOption(buttons[0], confirmed.emit)
	cursor.addOption(buttons[1], cancelled.emit)
	cursor.setActive(true)
	cursor.call_deferred("updatePosition")

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		cancelled.emit()
