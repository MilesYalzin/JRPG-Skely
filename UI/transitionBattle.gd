extends CanvasLayer
class_name BattleTransition

@onready var fade = $Control/fade

var fadeTime = 0.5
var holdTime = 0

signal fadeOutFinish
signal fadeInFinish

static func battleTrans(parent, _fadeTime := 0.5, _holdTime := 0.0):
	var t = preload("res://UI/transitionBattle.tscn").instantiate()
	t.fadeTime = _fadeTime
	t.holdTime = _holdTime
	parent.add_child(t)
	return t
	

func fadeOut():
	fade.play("fadeOut")
	await fade.animation_finished
	if holdTime > 0:
		await get_tree().create_timer(holdTime).timeout
	emit_signal("fadeOutFinish")


func fadeIn():
	fade.play("fadeIn")
	await fade.animation_finished
	emit_signal("fadeInFinish")
	queue_free()
