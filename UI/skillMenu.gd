extends Control
class_name  SkillMenu

const MENUSCENE : PackedScene = preload("res://UI/skillMenu.tscn")
var previousMenu
var character
var options
var isBattle := true


var selectedIndex = 1

@onready var buttonList = $PanelContainer/VBoxContainer
@onready var cursor = $Cursor

static func newSkillMenu(_char, parent, caller, _isBattle) -> SkillMenu:
	var menu = MENUSCENE.instantiate()
	
	menu.character = _char
	menu.isBattle = _isBattle
	menu.previousMenu = caller
	
	parent.add_child(menu)
	menu.options = menu.character.data.skills.slice(1, menu.character.data.skills.size())
	menu.showSkills()
	
	return menu

func showSkills():
	for skill in options:
		var btn = Button.new()
		btn.text = "%s MP %d" % [skill.displayName, skill.cost]
		
		var lowMP = character.data.baseStats.MP < skill.cost
		var wrongContext = skill.battleOnly and isBattle == false
		
		btn.disabled = lowMP or wrongContext
		btn.pressed.connect(skillSelected.bind(skill))
		
		buttonList.add_child(btn)
		updateCursor()
		updateDesc()
		
func skillSelected(ability):
	
	queue_free()
	$"../..".requestTargeting(character, ability)
	
func onCancel():
		queue_free()
		character.takeTurn()
	
func updateCursor():
	selectedIndex = clamp(selectedIndex,0,buttonList.get_child_count() - 1)
	var btn = buttonList.get_child(selectedIndex)
	cursor.position = btn.position + Vector2(-36, -8)
	
func updateDesc():
	$descBox/Label.text = options[selectedIndex].description
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		editIndex(1)
	elif Input.is_action_just_pressed("up"):
		editIndex(-1)
	elif Input.is_action_just_pressed("accept"):
		var ability = character.data.skills[selectedIndex + 1]
		skillSelected(ability)
	elif Input.is_action_just_pressed("cancel"):
		onCancel()
			#emit_signal("selected", opt)

func editIndex(dir:int):
	var count = buttonList.get_child_count()
	selectedIndex = (selectedIndex + dir + count) % count
	updateCursor()
	updateDesc()
