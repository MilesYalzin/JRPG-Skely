extends Control
class_name InventoryMenu

@onready var tabContainer: TabContainer = %TabContainer
@onready var infoBox: ItemInfoBox = %ItemInfoBox
var tabs: Dictionary[Item.Category, InventoryMenuItemList]

func _ready():
	for c in Item.Category.values():
		tabs[c] = InventoryMenuItemList.spawnItemList(tabContainer, self, c)
	for item in PlayerData.inventory:
		tabs[item.category].spawnItem(item)
	swapToTab(tabContainer.current_tab)

func _unhandled_key_input(event: InputEvent):
	var right := event.is_action_pressed(&"right")
	var left := event.is_action_pressed(&"left")
	if not (right or left): return
	swapToTab(tabContainer.current_tab + (0 + (1 if right else 0) + (-1 if left else 0)))
	
func getTabFromIdx(idx: int) -> InventoryMenuItemList:
	if tabs.is_empty(): return null
	return tabs[tabs.keys()[idx]]

func swapToTab(idx: int) -> void:
	tabContainer.current_tab = (tabContainer.get_tab_count() + idx) % tabContainer.get_tab_count()
	var t := getTabFromIdx(tabContainer.current_tab)
	if t: 
		if t.vbc.get_child_count() == 0: 
			infoBox.setItem(null)
		t.cursor.call_deferred(&"setActive")
