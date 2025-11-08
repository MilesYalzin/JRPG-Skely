extends Node
class_name MenuFactory

static func newMenu (_options:Array, parent: Node, _position:Vector2) -> MenuClass:
	return spawnMenu("res://UI/menuGeneric.tscn", _options, parent, _position)

static func newSideMenu (_options:Array, parent: Node, _position:Vector2) -> MenuClass:
	return spawnMenu("res://UI/sideMenu.tscn", _options, parent, _position, true)

static func spawnMenu(path: String, _options:Array, parent: Node, _position: Vector2, fill := false) -> MenuClass:
	var menuScene : PackedScene = load(path)
	var menuInstance : MenuClass = menuScene.instantiate()
	parent.add_child(menuInstance)
	
	menuInstance.position = _position
	menuInstance.setup(_options,fill)
	
	return menuInstance
