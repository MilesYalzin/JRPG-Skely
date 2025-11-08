extends Area2D


func slash_animation_finished() -> void:
	queue_free()
	



func _on_animation_frame_changed() -> void:
	var f = $Animation.frame
	if f >= 3 and f <= 5:
		$CollisionShape2D.disabled = false
	else:
		$CollisionShape2D.disabled = true
