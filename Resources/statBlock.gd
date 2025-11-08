extends Resource
class_name StatBlock

signal statsChanged
signal HPChanged(difference)

@export var maxHP = 10
@export var HP = 10
@export var maxMP = 10
@export var MP = 10
@export var atk = 10
@export var def = 10
@export var mgk = 10
@export var res = 10
@export var spd = 20
@export var ticks = 0
@export var tickBonus = 0

func changeHP(amount : int) -> void:
	#Positive = Damage Negative = Healin
	print("HP Before: ", HP, "  on ", self)

	HP = clamp (HP-amount, 0, maxHP)

	print("HP After: ", HP, "  on ", self)
	
	emit_signal("statsChanged")
	HPChanged.emit(amount)
	
func changeMP(amount : int) -> void:
	MP += amount
	emit_signal("statsChanged")
	
func changeSpd(amount : int) -> void:
	spd += amount
	
func changeTicks(amount : int) -> void:
	#print("Before: ", ticks, "  on ", self)
	ticks += amount
	#print("After: ", ticks, "  on ", self)

func setAdvantage(amount : int) -> void:
	tickBonus += amount
