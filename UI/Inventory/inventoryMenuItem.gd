extends Control
class_name InventoryMenuItem

var item: Item

static func spawnItem(_item: Item, _parent = null) -> InventoryMenuItem:
	var imi: InventoryMenuItem = load("uid://cxgx7mxukttn5").instantiate()
	imi.setItem(_item)
	if _parent:
		_parent.add_child(imi)
	return imi

func setItem(_item):
	item = _item
	await RPGUtils.until_ready(self)
	%NameLabel.text = item.name
	%AmtLabel.text = "x%s" % item.amount
