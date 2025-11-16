extends PanelContainer

@onready var layer = $"../../../.."
var menu: MenuClass

@onready var options := [
	#{"text": "Party", "action": Callable(layer, "swapToMenu").bind("uid://bitcnqnw6wkg8")},
	#{"text": "Inventory", "action": Callable(layer, "swapToMenu").bind()},
	#{"text": "Settings", "action": Callable(layer, "swapToMenu").bind()},
	{"text": "Save Game", "action": Callable(self, "saveGame")},
	{"text": "Load Game", "action": Callable(self, "loadGame")},
	{"text": "Quit", "action": Callable(self, "quitGame")}
]

func _ready() -> void:
	menu = MenuFactory.newSideMenu(options, self, Vector2(0,0))
	layer.swapToMenu("uid://bitcnqnw6wkg8")
#	menu.get_node("ButtonList").set_anchors_preset(Control.PRESET_FULL_RECT)

#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("left") and layer.menu:
#		menu.cursor.linkTo()

func saveGame():
	var confirm: Confirm = Confirm.spawnConfirm("Would you like to save?", layer)
	confirm.confirmed.connect(func():
		PlayerData.saveGame()
		print("Game saved!")
	)

func loadGame():
	var confirm = Confirm.spawnConfirm("Are you sure you want to load?", layer)
	confirm.confirmed.connect(func():
		var transition = TransitionEffect.play(get_tree().root, 0.5)
		await transition.fadeOut()
		PlayerData.loadGame()
		await transition.fadeIn()
		print("Gaem loaded")
	)
	
func quitGame():
	var confirm = Confirm.spawnConfirm("Are you sure you want to quit?", layer)
	confirm.confirmed.connect(get_tree().quit)
