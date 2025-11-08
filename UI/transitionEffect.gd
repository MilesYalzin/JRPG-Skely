extends CanvasLayer
class_name TransitionEffect

@onready var fade = $fade

var fadeTime = 0.5
var holdTime = 0

signal fadeOutFinish
signal fadeInFinish

static func play(parent, _fadeTime = 0.5, _holdTime = 0):
	var t = preload("res://UI/transitionEffect.tscn").instantiate()
	t.fadeTime = _fadeTime
	t.holdTime = _holdTime
	parent.add_child(t)
	return t
	

func fadeOut():
	fade.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, fadeTime)
	await tween.finished
	if holdTime > 0:
		await get_tree().create_timer(holdTime).timeout
	emit_signal("fadeOutFinish")


func fadeIn():
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, fadeTime)
	await tween.finished
	emit_signal("fadeInFinish")
	queue_free()
