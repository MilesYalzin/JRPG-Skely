extends CanvasLayer

var menu: Control

func _input(event) -> void:
	if event.is_action_pressed("pause"):
		queue_free()
		get_tree().call_deferred("set_pause", false)

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
