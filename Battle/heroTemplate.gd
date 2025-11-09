extends Node2D

@onready var currentBattle = self.get_parent()
@onready var UILayer = currentBattle.get_node("battleUI")
@onready var sprite = $AnimatedSprite2D
@onready var glow = preload("res://glowMaterial.tres")

var data : HeroData

var options = [
	{"text": "Attack", "action": Callable(self,"onAttack")},
	{"text": "Skills", "action": Callable(self,"onSkills")},
	{"text": "Flee", "action": Callable(self,"onFlee")}
]

var menu
var menuPos = Vector2(320,180)
var state = "idle"

func setup(instanceData : HeroData):
	data = instanceData
	data.baseStats.ticks = 0
	
	
	$AnimatedSprite2D.sprite_frames = data.sprite
	
	self.name = data.name
	
func _ready() -> void:
	setState(state)

func takeTurn():
	setState("ready")

	menu = MenuFactory.newMenu(options,UILayer,menuPos)

func onAttack():

	print("attack!!!")
	$"..".requestTargeting(self, data.skills[0])
	setState("attack")
	menu.queue_free()
	
func onSkills():
	var skillMenu = SkillMenu.newSkillMenu(self,UILayer,menu,true)
	skillMenu.position = menuPos
	menu.queue_free()

func onFlee():
	menu.queue_free()
	var fleeText = Label.new()
	fleeText.text = "Attempting to flee..."
	UILayer.add_child(fleeText)
	fleeText.position = Vector2(300,180)
	var roll = randi() % 100
	await  get_tree().create_timer(2.5).timeout
	
	if roll < currentBattle.fleeingChance:
		fleeText.text = "Ran away"
		await  get_tree().create_timer(1).timeout
		currentBattle.fled()
	else:
		fleeText.text = "Failed!"
		await  get_tree().create_timer(1).timeout
		var fleeAttemps = currentBattle.fleeAttempts + 1
		var chance = currentBattle.fleeingChance
		match fleeAttemps:
			1:
				chance += 20
			2: 
				chance += 10
			_: 
				chance += 5
		data.baseStats.changeTicks(-800)
		fleeText.queue_free()
		currentBattle.tickUp()

func getInfo() -> Dictionary:
	return {
		"name": data.name,
		"hp": str(data.baseStats.HP) + " / " +  str(data.baseStats.maxHP)
	}


func setState(newState):
	state = newState
	if state == "ready":
		sprite.material = glow
	else:
		sprite.material = null
	sprite.play(newState)
