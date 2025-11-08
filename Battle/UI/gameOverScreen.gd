extends Control

@onready var gameOver = $VBoxContainer/gameOver
@onready var menu = $VBoxContainer/menu
@onready var options = [$VBoxContainer/menu/Button,$VBoxContainer/menu/Button2]
@onready var cursor = $Cursor

var selectedIndex = 0

func _ready():
	gameOver.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(gameOver, "modulate:a", 1.0, 1.0)
	await tween.finished
	
	await get_tree().create_timer(1.0).timeout
	menu.visible = true
	cursor.visible = true
	call_deferred("updateCursor")
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("right"):
		selectedIndex = (selectedIndex + 1) % options.size()
		updateCursor()
	elif Input.is_action_just_pressed("up") or Input.is_action_just_pressed("left"):
		selectedIndex = (selectedIndex - 1 + options.size()) % options.size()
		updateCursor()
	elif Input.is_action_just_pressed("accept"):
		confirmOption()

func updateCursor():
	var option = options[selectedIndex]
	cursor.global_position = option.global_position + Vector2(-42, -4)
	
func confirmOption():
	match selectedIndex:
		0:
			pass
		1:
			pass
