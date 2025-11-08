extends Control

@onready var exp = $VBoxContainer/expLabel

signal finished
var readyToExit = false

var totalExp 
var leveledUp = []

func _ready() -> void:
	showVictory(totalExp)

func showVictory(totalExp):
	await get_tree().create_timer(1.0).timeout
	exp.visible = true
	exp.text = exp.text + str(totalExp)
	
	if leveledUp.is_empty() != true:
		await showLevelUps()
	
	readyToExit = true

func showLevelUps():
	for entry in leveledUp:
		$VBoxContainer/expLabel.visible = true
		$VBoxContainer/expLabel.text = "%s leveled up! %d → %d" % [entry.name, entry.level, entry.newLevel]
		await get_tree().create_timer(1.5).timeout
	

func _process(_delta: float) -> void:
	if readyToExit and Input.is_action_just_pressed("accept"):
		queue_free()
		emit_signal("finished")

func onLevelUp(heroName, level, newLevel):
	leveledUp.append(
		{"name": heroName, "level": level, "newLevel": newLevel }
	)
