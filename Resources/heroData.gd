extends Resource
class_name HeroData

enum Elements {none,fire,ice,metal,wood,earth}

@export var id: String
@export var name: String
@export var level := 1
@export var totalExp : int
@export var toNextLevel: int

@export var baseStats : StatBlock
@export var statGrowth : StatGrowth
var polyA: float = 10.0  #leveling up difficulty
var polyP: float = 2.0  #exponent
var maxLevel: int = 20

@export var sprite : SpriteFrames

@export var weakTo : Array[Elements]
@export var skills : Array[Skills]

signal levelUp(name, level, newLevel)

func totalExpForLevel(lvl: int):
	return int(round(100 + polyA * pow(float(lvl-2),polyP)))
	


func findLevel(total: int):
	var lvl := 1
	while lvl < maxLevel and total >= totalExpForLevel(lvl + 1):
		lvl += 1
	return lvl
	

func expToNext(currentLevel:int):
	if currentLevel >= maxLevel:
		return 0
	return totalExpForLevel(currentLevel + 1) - totalExpForLevel(currentLevel)
	
func addExp(amount:int):
	
	totalExp += amount
	var newLevel = findLevel(totalExp)
	
	if newLevel > level:
		levelUp.emit(name,level,newLevel)
		onLevelUp(newLevel)
		level = newLevel
	
	toNextLevel = expToNext(level)

func onLevelUp(newLevel: int):
	statGrowth.updateStats(baseStats, newLevel)
