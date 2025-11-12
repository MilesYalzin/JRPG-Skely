extends CharacterBody2D

@export var movementSpeed = 400

var facingDirection = Vector2.RIGHT
var slashScene = preload("res://Overworld/slash.tscn")
var pauseMenu = preload("res://UI/pauseMenu.tscn")
var canSlash = true
var cooldown = 1.5

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	if canSlash != false:
		movement()
	
	if Input.is_action_just_pressed("accept") and canSlash:
		slash()
		
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		var newMenu = pauseMenu.instantiate()
		add_child(newMenu)

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov,y_mov)
	
	if mov != Vector2.ZERO:
		facingDirection = mov.normalized()
		var animToPlay: StringName
		if abs(mov.x) > abs(mov.y):
			animToPlay = &"walkSide"
			anim.flip_h = mov.x > 0
		elif mov.y < 0:
			animToPlay = &"walkUp"
		else:
			animToPlay = &"walkDown"
		if anim.animation != animToPlay or not anim.is_playing():
			anim.play(animToPlay)
			anim.frame = 1
	else:
		anim.frame = 0
		anim.stop()
	
	velocity = mov.normalized()*movementSpeed
	move_and_slide()

func slash():
	canSlash = false
	
	var nuSlash = slashScene.instantiate()
	get_parent().add_child(nuSlash)
	nuSlash.global_position = global_position + (facingDirection * 24)
	
	if facingDirection.x < 0:
		nuSlash.scale.x = -1
	elif facingDirection.y != 0:
		nuSlash.rotation = facingDirection.angle()
	
	canSlash = true
	await get_tree().create_timer(cooldown).timeout
