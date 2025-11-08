extends VBoxContainer

var slotScene = preload("res://UI/characterInfo.tscn")
var maxSlots = 3


func populateSlots(party):
	for child in get_children():
		child.queue_free()
	for i in range(maxSlots):
			if i < party.size():
				var slot = slotScene.instantiate()
				var member = party[i]
				slot.get_node("portrait").texture = member.sprite
				slot.get_node("labels/name").text = member.name
				slot.get_node("labels/HP").text = "HP: " + str(member.baseStats.HP) + "/" + str(member.baseStats.maxHP)
				slot.get_node("labels/MP").text = "MP: " + str(member.baseStats.MP) + "/" + str(member.baseStats.maxMP)
				add_child(slot)
			else:
				var slot = Control.new()
				slot.size_flags_vertical = Control.SIZE_EXPAND_FILL
				add_child(slot)
