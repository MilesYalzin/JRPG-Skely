extends ColorRect
class_name Cursor

enum CursorAxis {X, Y, Both}

var options: Dictionary[Control, Dictionary]  ## A dictionary whose keys are controls to scroll thru, and values are.
var index := 0
## Whether or not the cursor is currently the active cursor. Setting this from the editor will set active to that value at ready.
@export var active := false
## Whether or not the cursor can move. Setting active to false will also disable movement.
var moveable := true
## The axis the cursor operates on.
@export var axis := CursorAxis.Both

static func spawnCursor(_parent = null, _axis := CursorAxis.Both, _active := false) -> Cursor:
	var c: Cursor = load("uid://c44kxw6bjv32a").instantiate()
	c.axis = _axis
	c.active = _active
	if _parent: _parent.add_child(c)
	return c
	
func _init():
	visible = false

func _ready():
	setActive(active)

func _unhandled_key_input(event: InputEvent) -> void:
	if not active or not moveable:
		return
	if (event.is_action_pressed("down") and axis in [CursorAxis.Y, CursorAxis.Both]) or (event.is_action_pressed("right") and axis in [CursorAxis.X, CursorAxis.Both]):
		editIndex(1)
	if (event.is_action_pressed("up") and axis in [CursorAxis.Y, CursorAxis.Both]) or (event.is_action_pressed("left") and axis in [CursorAxis.X, CursorAxis.Both]):
		editIndex(-1)
	elif event.is_action_pressed("accept"):
		doCallback("confirm")
		
func addOption(opt: Control, confirmCallable = null, scrolloverCallable = null, posOverride := Vector2.ZERO) -> void:
	options[opt] = {}
	visible = true
	if confirmCallable is Callable: options[opt]["confirm"] = confirmCallable
	if scrolloverCallable is Callable: options[opt]["scrollover"] = scrolloverCallable
	if posOverride != Vector2.ZERO: options[opt]["posOverride"] = posOverride
	updatePosition()
	
## Only set a cursor as active
func setActive(a := true):
	active = a
	visible = a and not options.is_empty()
	if not active: return
	editIndex(0)
	for cursor in RPGUtils.get_children_of_type(get_tree().root, Cursor, true):
		if cursor != self: cursor.setActive(false)

func editIndex(dir: int):
	var count = len(options)
	if count == 0: return
	index = (index + dir + count) % count
	updatePosition()
	doCallback("scrollover")
	
func getCurrentOption() -> Control:
	if options.is_empty(): return null
	return options.keys()[index]
	
func getCurrentOptDict() -> Dictionary:
	return options.get(getCurrentOption(), {})

func doCallback(cb: String) -> void:
	var callable = getCurrentOptDict().get(cb)
	if callable is Callable:
		callable.call()

func updatePosition():
	var opt: Control = getCurrentOption()
	if not opt: return
	var optDict := getCurrentOptDict()
	var offset = optDict.get("posOverride", Vector2.ZERO) + Vector2(-size.x - 4, opt.size.y / 2 - size.y / 2)
	position = opt.global_position - get_parent().global_position + offset
