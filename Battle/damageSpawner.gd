extends Control

@export var drift = 50
@export var lifetime = 5
@export var holdTime = 2.5

func setup(unitArray):
	for unit in unitArray:
		unit.data.baseStats.HPChanged.connect(Callable(self, "spawnNumber").bind(unit))
		

func spawnNumber(damage, unit):
	var number = Label.new()

	number.pivot_offset = size / 2
	number.text = str(damage)
	add_child(number)
	
	number.global_position = unit.global_position / 2
	
	var towardCenter = ( self.global_position - number.global_position ).normalized() / 2
	
	
	var popDir = (Vector2(0, -1) * 0.8 + towardCenter * 0.2).normalized() / 2
	var popDistance = drift * randf_range(0.8, 1.2)
	var popPos = number.global_position + popDir * popDistance
	
	var driftDir = (Vector2(0, 1) * 0.3 + towardCenter * 0.7).normalized() 
	var driftDistance = drift * randf_range(0.2, 0.5)
	var endPos = popPos + driftDir * driftDistance
	
	var tween = create_tween()
	
	tween.tween_property(number, "global_position", popPos, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_interval(holdTime)
	tween.parallel().tween_property(number, "global_position", endPos, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(number, "modulate:a", 0.0, 0.8)
	
	tween.finished.connect(number.queue_free)
