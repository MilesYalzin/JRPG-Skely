extends Node


@export var specialChance = 0.33
@onready var parent = $".."
@onready var battleManager = $"../.."
var foeArray 
var allyArray
var chosen

func _ready() -> void:
	foeArray = battleManager.heroArray
	allyArray = battleManager.enemyArray
	
func pickSkill():
	if randf() > specialChance and parent.data.skills.size() > 1:
		chosen = parent.data.skills[1]
	else:
		chosen = parent.data.skills[0]
	pickTarget(chosen)
	
func pickTarget(skill):
	var targets = []
	
	match chosen.validTargets:
		Skills.Targets.Self:
			targets = [self]
		Skills.Targets.Enemies:
			targets = foeArray
		Skills.Targets.Allies:
			targets = allyArray
		Skills.Targets.All:
			targets = foeArray
	
	if not skill.isAoE:
		if targets.size() > 0:
			var currentLowest = targets[0]
			for unit in targets:
				if unit.data.baseStats.HP < currentLowest.data.baseStats.HP:
					currentLowest = unit
			targets = currentLowest
	chosen.executeAbility(parent, targets)
