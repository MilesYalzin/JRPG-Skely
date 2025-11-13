extends Resource 

class_name BattleStatus

enum TRIGGER {pre, post, onhit}
enum TYPE {Buff,Debuff,StatusCon}

#aesthetic components
@export var name : String
@export var icon : Texture2D
@export_multiline var effectDescription : String

#tracking data
@export var defaultTurns : int #(how many turns it lasts by default)
var remainingTurns : int #(how many turns until it wears off)
@export var stackable: bool = true
@export var stacksToApply : int = 1 #stacks are pretty essential for buffs and debuffs
var currentStacks : int = 0


#logic data
@export var timing : TRIGGER
@export var type: TYPE
@export var effect : Script:
	set(value):
		if value!=null:
			effect = 	value.new()
@export var chance : float 

func rollChance(target):
	if randf() > chance:
		target.status.statuses.append()

func runEffect():
	effect.apply()
