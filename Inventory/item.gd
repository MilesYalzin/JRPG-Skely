extends Resource
class_name Item

enum Category {Misc, Equip, KeyItem}

@export var name: String
@export var pluralName: String
@export var icon: Texture2D
@export_multiline var description: String
@export var maxAmount := 1
@export var category := Category.Misc

var amount := 0:
	set(x):
		amount = clampi(x, 0, maxAmount)

#region Components

@export var components: Array[ItemComponent]

func getComponentProperty(property: StringName, first_only := true) -> Variant:
	var all = []
	for component in components:
		var p = component.get(property)
		if p: 
			if first_only: return component.get(property)
			else: all.append(p)
	if not first_only:
		return all
	return null

func setComponentProperty(property: StringName, value: Variant, first_only := true) -> void:
	for component in components:
		if component.get(property) != null:
			component.set(property, value)
			if first_only:
				return
	
func componentCall(fn: StringName, args: Array, first_only := true) -> Variant:
	var all = []
	for component in components:
		if component.has_method(fn): 
			var r = component.callv(fn, args)
			if r: 
				if first_only: return r
				else: all.append(r)
	if not first_only:
		return all
	return null

#endregion

#region Serialization

var serializedProperties := [&"resource_path", &"amount"]

func serialize() -> Dictionary:
	var s := {}
	for property in serializedProperties:
		s[property] = get(property)
	for component in components:
		var sp = component.get(&"serializedProperties")
		if not sp: sp = []
		for property in sp:
			if not component.resource_path in s:
				s[component.resource_path] = {}
			s[component.resource_path][property] = component.get(property)
	return s

static func deserialize(data: Dictionary) -> Item:
	var path: String = data.get("resource_path", "")
	if not path.is_absolute_path():
		return null
	var item = load(path)
	if not item is Item:
		return null
	for property in data:
		if property in item.serializedProperties:
			match property:
				"resource_path": pass
				_: item.set(property, data[property])
	if item.amount == 0:
		return null
	for component: ItemComponent in item.components:
		var cdata: Dictionary = data.get(component.resource_path, {})
		for property in cdata:
			var sp = component.get(&"serializedProperties")
			if not sp: sp = []
			if property in sp:
				component.set(property, cdata[property])
	return item
	
#endregion
