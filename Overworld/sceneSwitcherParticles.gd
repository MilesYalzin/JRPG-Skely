@tool
extends NinePatchRect

enum DIRECTION { Left, Right, Top, Bottom }

@export var towards : DIRECTION = DIRECTION.Right

@export var textures : Array[Texture]

func _ready() -> void:
	matchVisual()
	

func _process(_delta):
	if Engine.is_editor_hint():
		matchVisual()

func matchVisual():
	texture = textures[towards]
