extends CanvasLayer

var ignoreInput = true

func _ready() -> void:
	$Control/HBoxContainer/PanelContainer/partyInfo.populateSlots(PlayerData.currentParty)

func _process(_delta: float) -> void:
	if ignoreInput:
		ignoreInput = false
		return
		
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		queue_free()
		ignoreInput = true
