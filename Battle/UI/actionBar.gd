extends Panel

var actionSlot = preload("res://Battle/UI/actionSlot.tscn")
var activeUnits = {}

@onready var container = $slotContainer

func ensureSlots(units):
	for u in units:
		if not activeUnits.has(u):
			var slot = actionSlot.instantiate()
			slot.text = u.name
			container.add_child(slot)
			activeUnits [u] = slot
	
	
	for key in activeUnits.keys():
		if not units.has(key):
			activeUnits[key].queue_free()
			activeUnits.erase(key)


func sortTurns(units):
	var ordered = units.duplicate()
	ordered.sort_custom(Callable(self,"compareTicks"))
	
	for i in range(ordered.size()):
		var u = ordered[i]
		var slot = activeUnits[u]
		container.move_child(slot, i)


func updateActionBar(units):
	ensureSlots(units)
	for u in units:
		var s = activeUnits[u]
		#print(u.name, u.data.baseStats.ticks)
		var frac = clamp(u.data.baseStats.ticks / 1000.0, 0.0, 1.0)
		#print(" → frac:", frac)
		s.get_node("ProgressBar").value = frac * 100

	

func compareTicks(a,b):
	return int(b.data.baseStats.ticks - a.data.baseStats.ticks)
