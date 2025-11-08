extends VBoxContainer

var slotScene = preload("res://Battle/UI/playerUISlot.tscn")
var maxSlots = 3
var partyMemb = []
var slots = []

func populateSlots(party):
	partyMemb = party
	slots.clear()
	
	for child in get_children():
		child.queue_free()

	for i in range(maxSlots):
		if i < party.size():
			var slot = slotScene.instantiate()
			add_child(slot)
			slots.append(slot)
			
			slot.get_node("name").text = str(party[i].data.name)
			updateSlot(i)
			
			party[i].data.baseStats.connect("statsChanged", Callable(self, "updateSlot").bind(i))


func updateSlot(i):
	if i > partyMemb.size():
		return
	var unit = partyMemb[i]
	var slot = slots[i]
	slot.get_node("HPLabel").text = str(unit.data.baseStats.HP) + " / " + str(unit.data.baseStats.maxHP)
	slot.get_node("MPLabel").text = str(unit.data.baseStats.MP) + " / " + str(unit.data.baseStats.maxMP)
