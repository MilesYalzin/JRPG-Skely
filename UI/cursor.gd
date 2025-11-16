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

func _ready():
	setActive(active)

func _input(event: InputEvent) -> void:
	if not active or not moveable:
		return
	if (event.is_action_pressed("down") and axis in [CursorAxis.Y, CursorAxis.Both]) or (event.is_action_pressed("right") and axis in [CursorAxis.X, CursorAxis.Both]):
		editIndex(1)
	if (event.is_action_pressed("up") and axis in [CursorAxis.Y, CursorAxis.Both]) or (event.is_action_pressed("left") and axis in [CursorAxis.X, CursorAxis.Both]):
		editIndex(-1)
	elif event.is_action_pressed("accept"):
		doCallback("confirm")
		
func addOption(opt: Control, confirmCallable = null, scrolloverCallable = null) -> void:
	options[opt] = {}
	if confirmCallable is Callable: options[opt]["confirm"] = confirmCallable
	if scrolloverCallable is Callable: options[opt]["scrollover"] = scrolloverCallable
	
## Only set a cursor as active
func setActive(a := true):
	active = a
	visible = active
	if not active: return
	updatePosition()
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

func doCallback(cb: String) -> void:
	var callable = options.get(getCurrentOption(), {}).get(cb, null)
	if callable is Callable:
		callable.call()

func updatePosition():
	var opt: Control = getCurrentOption()
	if not opt: return
	var offset = Vector2(-size.x - 4, opt.size.y / 2 - size.y / 2)
	position = opt.global_position - get_parent().global_position + offset
