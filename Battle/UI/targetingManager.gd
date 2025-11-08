extends Node2D
class_name TargetingManager

const MANAGER = preload("res://Battle/UI/targetingManager.tscn")
@onready var info = $targetInfo
var caster
var ability
var validTargets
var index = 0
var isAoE = false
var cursors = []

@onready var cursor = $Cursor
const CURSOR_OFFSET = Vector2(40, -16)

static func newManager(_caster, _ability, _validTargets):
	var manager = MANAGER.instantiate()
	manager.caster = _caster
	manager.ability = _ability
	manager.validTargets = _validTargets
	manager.isAoE = _ability.isAoE

	return manager

func _ready() -> void:
	await get_tree().process_frame
	
	if isAoE:
		moveCursorsToAll()
	else:
		moveCursorToIndex(0)


func _process(_delta: float) -> void:
	if isAoE:
		if Input.is_action_just_pressed("accept"):
			confirmTarget()
		if Input.is_action_just_pressed("cancel"):
			cancelTarget()
		return

	var x_mov = 0.0
	var y_mov = 0.0
	var moved = false

	if Input.is_action_just_pressed("right"):
		x_mov = 1.0
		moved = true
	elif Input.is_action_just_pressed("left"):
		x_mov = -1.0
		moved = true
		
	if Input.is_action_just_pressed("down"):
		y_mov = 1.0
		moved = true
	elif Input.is_action_just_pressed("up"):
		y_mov = -1.0
		moved = true
	
	var mov = Vector2(x_mov, y_mov)
	
	if moved:
		moveCursorInDirection(mov.normalized())
	

	if Input.is_action_just_pressed("accept"):
		confirmTarget()
	if Input.is_action_just_pressed("cancel"):
		cancelTarget()

func moveCursorsToAll():
	for t in validTargets:
		var c = cursor.duplicate()
		add_child(c)
		c.global_position = t.global_position + CURSOR_OFFSET
		c.show()
		cursors.append(c)
		
		var infoClone = info.duplicate()
		add_child(infoClone)
		var curr = t.getInfo()
		infoClone.get_node("Name").text = curr["name"]
		infoClone.get_node("HP").text = curr["hp"]
		infoClone.global_position = c.global_position + Vector2(48, 20)

func moveCursorToIndex(dir):
	index = clamp(dir,0,validTargets.size()-1)
	cursor.global_position = validTargets[index].global_position + CURSOR_OFFSET
	updateTargetInfo(validTargets[index])
	
func moveCursorInDirection(dir: Vector2):
	if validTargets.size() == 1:
		moveCursorToIndex(0)
		return
	var currPos = validTargets[index].global_position
	var perpendicular = Vector2(-dir.y, dir.x)
	
	var bestIndex = -1
	var bestCost = INF
	
	for i in range(validTargets.size()):
		if i == index: continue
		var relative = validTargets[i].global_position - currPos
		var forward = relative.dot(dir)
		if forward <= 0:
			continue
		var lateral = abs(relative.dot(perpendicular))
		var cost = forward + lateral * 1.25
		if cost < bestCost:
			bestCost = cost
			bestIndex = i
		
	if bestIndex == -1:
		var min_d = INF
		for i in range(validTargets.size()):
			if i == index: continue
			var d = validTargets[i].global_position.distance_to(currPos)
			if d < min_d:
				min_d = d
				bestIndex = i
	
	moveCursorToIndex(bestIndex)

func updateTargetInfo(target):
	var curr = target.getInfo()
	info.get_node("Name").text = curr["name"]
	info.get_node("HP").text = curr["hp"]
	info.global_position = cursor.global_position + Vector2(48, 20)

func confirmTarget():
	var target
	if !isAoE:

		target = validTargets[index]
	else:

		target  = validTargets
	ability.executeAbility(caster, target)
	queue_free()
	$"..".victoryCheck()
	
func cancelTarget():
	queue_free()
	caster.takeTurn()
