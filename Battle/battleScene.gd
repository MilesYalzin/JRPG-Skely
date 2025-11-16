extends Node2D
class_name BattleScene

const BATTLE_SCENE: PackedScene = preload("res://Battle/battleScene.tscn")
@onready var enemyScene = preload("res://Battle/enemyTemplate.tscn")
@onready var heroScene = preload("res://Battle/heroTemplate.tscn")
@onready var enemySpawnPoints = $enemySpawnPoints.get_children()
@onready var heroSpawnPoints = $heroSpawnPoints.get_children()
@onready var actionBar = $battleUI/topUI/actionBar
@onready var playerUI = $battleUI/topUI/PanelContainer/playerUI

var music
var background

var enemyArray
var heroArray
var koArray = []
var unitArray

var preempt
var expPool = 0

var fleeingChance = 50.0
var fleeAttempts = 0

signal battleEnded(victory: bool)

static func newBattle(_music: AudioStreamOggVorbis, _background: Texture2D, _enemyArray, _heroArray:Array, collided):
	var battle = BATTLE_SCENE.instantiate()
	battle.music = _music
	battle.background = _background
	
	battle.enemyArray = []
	for t in _enemyArray.troops:
		battle.enemyArray.append(t)

	battle.heroArray = _heroArray.duplicate()
	
	if collided.name == "playerArea":
		battle.preempt = false
	elif collided.name == "Slash":
		battle.preempt = true
	
	return battle

func _ready() -> void:
	$Sprite2D.texture = background
	$musicPlayer.stream = music
	$musicPlayer.play()
	$Camera2D.make_current()
	setupEnemies(enemyArray)
	setupHeroes(heroArray)
	unitArray = heroArray + enemyArray
	playerUI.populateSlots(heroArray)
	initializeBattle()


func setupEnemies(_enemyArray):
	var letters = "ABCDEFGH"
	var typeCounts = {} #count how many of each type of enemy is spawning
	var typeSpawned = {}
	
	for id in _enemyArray:
		var data = id
		var baseName = data.name
		typeCounts[baseName] = typeCounts.get(baseName,0) + 1

	for i in _enemyArray.size():
		var data = _enemyArray[i]
		var inst = enemyScene.instantiate()
		inst.setup(data)
		inst.position = enemySpawnPoints[i].global_position
		
		var baseName = data.name
		typeSpawned[baseName] = typeSpawned.get(baseName,0) + 1
		
		if typeCounts[baseName] > 1:
			var suffix = letters[typeSpawned[baseName] - 1] 
			inst.name = "%s %s" % [baseName,suffix]
		else:
			inst.name = baseName
		
		add_child(inst)
		enemyArray[i] = inst

func setupHeroes(_heroArray):
	for i in _heroArray.size():
		var data = _heroArray[i]
		var inst = heroScene.instantiate()
		inst.setup(data)
		inst.position = heroSpawnPoints[i].global_position
		add_child(inst)
		heroArray[i] = inst

func initializeBattle():
	if preempt == true:
		for enemy in enemyArray:
			var base = enemy.data.baseStats.spd 
			var initiative = randi_range(base / 2, base)
			enemy.data.baseStats.changeTicks(initiative)
	elif preempt == false:
		for enemy in enemyArray:
			var base = enemy.data.baseStats.spd 
			var initiative = randi_range(base, base * 2)
			enemy.data.baseStats.changeTicks(initiative)
	
	
	$battleUI/damageSpawner.setup(unitArray)
	
	
	tickUp()

func tickUp():
	while true:
		for current in unitArray:
			current.data.baseStats.changeTicks(current.data.baseStats.spd)
		

		actionBar.updateActionBar(unitArray)
		actionBar.sortTurns(unitArray)
		await get_tree().process_frame
		
		for current in unitArray:
			if current.data.baseStats.ticks >= 1000:
				current.takeTurn()
				return
		

func victoryCheck():
	for i in range(enemyArray.size() -1, -1, -1):
		var enemy = enemyArray[i]
		if enemy.data.baseStats.HP <= 0:
			expPool += enemy.data.expDrop
			enemyArray.remove_at(i)
			unitArray.erase(enemy)
			enemy.queue_free()
	for i in range(heroArray.size() -1, -1, -1):
		var hero = heroArray[i]
		if hero.data.baseStats.HP <= 0:
			heroArray.remove_at(i)
			unitArray.erase(hero)
			koArray.append(hero)
			hero.visible = false
	
	if enemyArray.is_empty():
		endBattle(true)
	elif heroArray.is_empty():
		endBattle(false)
	else:	
		tickUp()
	
func endBattle(goodEnding : bool):
	if goodEnding == true:
		var victoryUI = preload("res://Battle/UI/victoryScreen.tscn").instantiate()
		victoryUI.totalExp = expPool
		$battleUI.add_child(victoryUI)
		victoryUI.finished.connect(victoryFinished)
		for hero in heroArray:
			hero.data.levelUp.connect(victoryUI.onLevelUp)
			hero.data.addExp(expPool)
		for hero in koArray:
			hero.data.baseStats.HP += 1
	elif goodEnding == false:
		var gameoverUI = preload("res://Battle/UI/gameOverScreen.tscn").instantiate()
		$battleUI.add_child(gameoverUI)


func requestTargeting(caster, ability):
	var targets
	match ability.validTargets:
		Skills.Targets.Self:
			targets = caster
		Skills.Targets.Enemies:
			targets = enemyArray
		Skills.Targets.Allies:
			targets = heroArray
		Skills.Targets.All:
			targets = unitArray
	var targetManager = TargetingManager.newManager(caster, ability, targets)
	add_child(targetManager)

func victoryFinished():
	get_tree().paused = false
	emit_signal("battleEnded", true)
	queue_free()

func fled():
	get_tree().paused = false
	emit_signal("battleEnded", false)
	queue_free()
