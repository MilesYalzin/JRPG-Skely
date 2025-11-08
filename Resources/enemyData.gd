extends Resource
class_name EnemyData

enum Elements {none,fire,ice,metal,wood,earth}

@export var id: String
@export var num: int
@export var name: String

@export var baseStats: StatBlock
@export var AI: PackedScene
@export var sprite: Texture2D
@export var expDrop: int
#@export var loot: 

@export var skills : Array[Skills]
@export var weakTo : Array[Elements]
