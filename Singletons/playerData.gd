extends Node

var location : String
var position_x : int
var position_y : int

var currentParty = []

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	var re = load("res://Heroes/Cirno.tres")

	
	currentParty = [re.duplicate(true)]
	

func collectData(_player: Node):
	position_x = _player.global_position.x
	position_y = _player.global_position.y
	
func toDict() -> Dictionary:
	var partyPaths: Array = []
	for r in currentParty:
		if r:
			partyPaths.append(r.resource_path)

	var d := {
			"location": location,
			"position": {"x": position_x, "y": position_y},
			
			"currentParty": partyPaths,
			
			"keyManager": {
				"chests": KeyManager.chests,
				"quests": KeyManager.quests,
				"cutscenes": KeyManager.cutscenes
			}
	}
	return d

func fromDict(data:Dictionary):

	var scenePath = str(data.get("location"))
	location = scenePath

	
	currentParty = []
	for path in data.get("currentParty", []):
		var res = load(path)
		if res:
			currentParty.append(res)
			
			
	if data.has("keyManager"):
		var km = data["keyManager"]
		KeyManager.chests = km.get("chests", {})
		KeyManager.quests = km.get("quests", {})
		KeyManager.cutscenes = km.get("cutscenes", {})

	if location != "":
		var loaded = load(location) as PackedScene
		var newScene = loaded.instantiate()
		get_tree().root.add_child(newScene)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = newScene

	var pos = data.get("position", {})
	position_x = int(pos.get("x", 0))
	position_y = int(pos.get("y", 0))

	call_deferred("applyData")


func applyData():
	var _player = get_tree().current_scene.get_node("playerOverworld")
	_player.global_position = Vector2(position_x,position_y)
	get_tree().paused = false

func saveGame(path := "user://save.json"):
	var dir = DirAccess.open("user://")
	if dir and not dir.dir_exists("units"):
		dir.make_dir("units")


	for unit in currentParty:
		if unit:
			var copy = unit.duplicate(true)
			var unitName = "%s_%s.tres" % [unit.name, path.get_file().get_basename()]
			var unitPath = "user://units/%s" % unitName
			ResourceSaver.save(copy, unitPath)
			unit.resource_path = unitPath

	var player = get_tree().get_nodes_in_group("player")[0]
	self.collectData(player)
	
	var saveDict = self.toDict()
	var json = JSON.stringify(saveDict, "\t")
	
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	if file:
		file.store_string(json)
		file.close()

func loadGame(path := "user://save.json"):
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Save file not found")
		return

	var content = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(content)
	
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Save file does not contain a valid dictionary")
		return # safety to ensure bad files aren't loaded
		
	fromDict(parsed)

func autoSave():
	saveGame("user://autosave.json")

func autoLoad():
	loadGame("user://autosave.json")
