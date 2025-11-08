extends Node2D

@export var battleMusic : AudioStreamOggVorbis
@export var battleScenario: Texture2D
@export var troops : Array[TroopData]
var enemyArray
var playerArray

@export var music : String
@export var path : String

func _ready():
	if music != "":
		AudioManager.playMusic(music, false, true)
	PlayerData.location = path
	randomize()
	PlayerData.autoSave()

func startBattle(blob, preempt):
	enemyArray = troops[randi_range(0,troops.size()-1)]
	playerArray = PlayerData.currentParty
	
	get_tree().paused = true
	
	var transition = BattleTransition.battleTrans(get_tree().root, 2.5, 2.5)
	
	await transition.fadeOut()

	var battle = BattleScene.newBattle(battleMusic,battleScenario, enemyArray, playerArray, preempt)
	add_child(battle)
	
	battle.connect("battleEnded", Callable(blob, "battleExited"))
	
	await transition.fadeIn()
