extends CharacterBody2D

@export var stage : Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	stage.startBattle(self, area)

func battleExited(victory: bool):
	if victory:
		queue_free()
	else:
		$Area2D.monitoring = false
		var sprite = $Sprite2D
		sprite.modulate.a = 0.5
		
		await get_tree().create_timer(8).timeout
		
		var tween := create_tween().set_loops() 
		tween.tween_property(sprite, "modulate:a", 1.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite, "modulate:a", 0.5, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		await get_tree().create_timer(1.0).timeout
		
		tween.kill()
		
		var fastTween = create_tween().set_loops() 
		fastTween.tween_property(sprite, "modulate:a", 1.0, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		fastTween.tween_property(sprite, "modulate:a", 0.5, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		await get_tree().create_timer(1.0).timeout
		fastTween.kill()
		sprite.modulate.a = 1.0
		
		$Area2D.monitoring = true
