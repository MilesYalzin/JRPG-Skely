extends CanvasLayer
class_name PauseMenu

var menu: Control
@onready var sideMenu: SideMenu = %sideMenu

func _input(event: InputEvent) -> void:
	var pause := event.is_action_pressed(&"pause")
	var cancel := event.is_action_pressed(&"cancel")
	if pause or cancel:
		if menu and cancel:
			menu.queue_free()
			sideMenu.menu.cursor.setActive()
		else:
			queue_free()
			get_tree().call_deferred(&"set_pause", false)

func swapToMenu(path: String, ...args: Array):
	if menu:
		menu.queue_free()
		menu = null
	var menuResource = load(path)
	if menuResource is GDScript: 
		menu = menuResource.new.callv(args)
	elif menuResource is PackedScene: 
		menu = menuResource.instantiate()
	%PanelContainer.add_child(menu)
