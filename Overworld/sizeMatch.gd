@tool
extends CollisionShape2D

@onready var parent = $"../.."

func _ready() -> void:
	updateShape()
	

func _process(_delta):
	if Engine.is_editor_hint():
		updateShape()

func updateShape():
	shape = shape.duplicate(true)
	shape.size = parent.size

	global_position = parent.global_position + parent.size * 0.5
	
