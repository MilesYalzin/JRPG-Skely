extends Node2D

var data: EnemyData
var AINode: Node
@onready var status = $StatusManager

func setup(instanceData : EnemyData):
	data = instanceData.duplicate(true)
	$Sprite2D.texture = data.sprite

func _ready() -> void:
	AINode = data.AI.instantiate()
	add_child(AINode)

func takeTurn():
	AINode.pickSkill()
	$"..".victoryCheck()
	
func getInfo() -> Dictionary:
	return {
		"name": self.name,
		"hp": str(data.baseStats.HP) + " / " +  str(data.baseStats.maxHP)
	}
