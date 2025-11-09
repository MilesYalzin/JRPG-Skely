extends ColorRect
class_name Cursor

var menu: MenuClass
var index :int = 0

func linkTo(_menu: MenuClass):
	menu = _menu
	updatePosition()
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		editIndex(1)
	elif Input.is_action_just_pressed("up"):
		editIndex(-1)
	elif Input.is_action_just_pressed("accept"):
		confirm()


func editIndex(dir:int):
	var count = menu.get_count()
	if count == 0: return
	index = (index + dir + count) % count
	updatePosition()
	
func confirm():
	print(index)
	var opt = menu.options[index]
	if opt is Dictionary and opt.get("enabled",true):
		opt["action"].call()

func updatePosition():
	var btn = menu.get_button(index)
	var offset = Vector2(-size.x - 4, btn.size.y / 2 - size.y / 2)
	position = btn.global_position - get_parent().global_position + offset
