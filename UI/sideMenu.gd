extends PanelContainer

@onready var layer = $"../../../.."
var menu 

var options = [
	#{"text" : "Formation", "enabled" : false},
#	{"text" : "Stats", "enabled" : false},
#	{"text" : "Skills", "enabled" : false},
	#{"text" : "Quests", "enabled" : false},
	#{"text": "Settings", "enabled": false, "action": Callable(self, "openSettings")},

	{"text": "Save Game", "enabled": true, "action": Callable(self, "saveGame")},
	{"text": "Load Game", "enabled": true, "action": Callable(self, "loadGame")},

	{"text": "Quit", "enabled": true, "action": Callable(self, "quitGame")}
]

func _ready() -> void:
	menu = MenuFactory.newSideMenu(options, self, Vector2(0,0))
#	menu.get_node("ButtonList").set_anchors_preset(Control.PRESET_FULL_RECT)

func saveGame():
	var confirm = Confirm.spawnConfirm("Would you like to save?",layer, menu)
	confirm.confirmed.connect(func():
		PlayerData.saveGame()
		)
		

	print("Game saved!")
	
func loadGame():
	var confirm = Confirm.spawnConfirm("Are you sure you want to load?",layer, menu)
	confirm.confirmed.connect(func():
		var transition = TransitionEffect.play(get_tree().root, 0.5)
		await transition.fadeOut()
		PlayerData.loadGame()
		await transition.fadeIn()
		)
	print("Gaem loaded")
	
func quitGame():
	var confirm = Confirm.spawnConfirm("Are you sure you want to quit?",layer, menu)
	confirm.confirmed.connect(get_tree().quit)
