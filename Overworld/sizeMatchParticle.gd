@tool
extends GPUParticles2D

@onready var parent = $".."
@onready var mat = process_material 

func _ready() -> void:
	updateShape()
	

func _process(_delta):
	if Engine.is_editor_hint():
		updateShape()

func updateShape():
	var targetSize = parent.size
	match parent.towards:
		parent.DIRECTION.Right:
			position.y = parent.size.y * 0.5
			position.x = 0.0
			mat.emission_box_extents = Vector3(0.5, targetSize.y * 0.5, 0.0)
			mat.direction = Vector3(1.0,0.0,0.0)
		parent.DIRECTION.Left:
			position.y = parent.size.y * 0.5
			position.x = parent.size.x
			mat.emission_box_extents = Vector3(0.5, targetSize.y * 0.5, 0.0)
			mat.direction = Vector3(-1.0,0.0,0.0)
		parent.DIRECTION.Top:
			position.y = parent.size.y
			position.x = parent.size.x * 0.5
			mat.emission_box_extents = Vector3(targetSize.x * 0.5, 0.5, 0.0)
			mat.direction = Vector3(0.0,-1.0,0.0)
		parent.DIRECTION.Bottom:
			position.y = 0.0
			position.x = parent.size.x * 0.5
			mat.emission_box_extents = Vector3(targetSize.x * 0.5, 0.5, 0.0)
			mat.direction = Vector3(0.0,1.0,0.0)
