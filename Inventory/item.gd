extends Resource
class_name Item

@export var name: String
@export var pluralName: String
@export_multiline var description: String

var amount: int = 0

func serialize() -> Dictionary:
	return {"resource_path": resource_path, "amount": amount}

static func deserialize(data: Dictionary) -> Item:
	var item = load(data["resource_path"])
	if not item is Item:
		return null
	for property: String in data:
		if property != "resource_path":
			item.set(property, data[property])
	return item
