extends Control
class_name InventoryMenuItemList

var category := Item.Category.Misc
var cursor: Cursor
var menu: InventoryMenu

@onready var vbc: VBoxContainer = %VBoxContainer

static func spawnItemList(_parent: Control, _menu: InventoryMenu, _category: Item.Category) -> InventoryMenuItemList:
	var itemList := load("uid://c3fprn5g5j3i8").instantiate() as InventoryMenuItemList
	itemList.category = _category
	itemList.menu = _menu
	itemList.name = RPGUtils.get_enum_value_name(Item.Category, _category)
	_parent.add_child(itemList)
	return itemList
	
func _ready():
	cursor = Cursor.spawnCursor(self, Cursor.CursorAxis.Y)

func spawnItem(item: Item) -> InventoryMenuItem:
	var imi := InventoryMenuItem.spawnItem(item, vbc)
	cursor.addOption(imi, null, menu.infoBox.setItem.bind(item), Vector2(0.0, 20.0))
	return imi
