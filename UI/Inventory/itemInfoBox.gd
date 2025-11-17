extends VBoxContainer
class_name ItemInfoBox

var item: Item

static func spawnItemBox(_item: Item, _parent = null) -> ItemInfoBox:
	var ibox: ItemInfoBox = load("uid://cnw2ctp8la8wr").instantiate()
	ibox.setItem(_item)
	if _parent:
		_parent.add_child(ibox)
	return ibox

func setItem(_item: Item):
	item = _item
	visible = item != null
	if not visible:
		return
	await RPGUtils.until_ready(self)
	%NameLabel.text = item.name
	%DescLabel.text = item.description
	%IconTextureRect.texture = item.icon
