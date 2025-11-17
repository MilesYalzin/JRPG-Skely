extends PanelContainer
class_name SideMenu

@onready var pauseMenu: PauseMenu = $"../../../.."
var menu: MenuClass

@onready var options := [
	{"text": "Party", "action": pauseMenu.swapToMenu.bind("uid://bitcnqnw6wkg8")},
	{"text": "Inventory", "action": pauseMenu.swapToMenu.bind("uid://biexk5x246fp7")},
	#{"text": "Settings", "action": pauseMenu.swapToMenu.bind()},
	{"text": "Save Game", "action": Callable(self, "saveGame")},
	{"text": "Load Game", "action": Callable(self, "loadGame")},
	{"text": "Quit", "action": Callable(self, "quitGame")}
]

func _ready() -> void:
	menu = MenuFactory.newSideMenu(options, self, Vector2(0,0))
	pauseMenu.call_deferred(&"swapToMenu", "uid://bitcnqnw6wkg8")

func saveGame():
	var confirm: Confirm = Confirm.spawnConfirm("Would you like to save?", pauseMenu)
	confirm.confirmed.connect(func():
		PlayerData.saveGame()
		print("Game saved!")
	)

func loadGame():
	var confirm = Confirm.spawnConfirm("Are you sure you want to load?", pauseMenu)
	confirm.confirmed.connect(func():
		var transition = TransitionEffect.play(get_tree().root, 0.5)
		await transition.fadeOut()
		PlayerData.loadGame()
		await transition.fadeIn()
		print("Gaem loaded")
	)
	
func quitGame():
	var confirm = Confirm.spawnConfirm("Are you sure you want to quit?", pauseMenu)
	confirm.confirmed.connect(get_tree().quit)
