extends CharacterBody2D

var currPos = Vector2(0, 0)
var targetPos = Vector2(0, 0)
var moving = false

var normal_speed = 200.0
var current_speed = normal_speed
var previous_direction = Vector2.ZERO

var move_duration = 0.2
var water_collision_layer = 2  
var slippery_tile_id = 5 

func _physics_process(delta):
	if moving:
		return
	
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction = Vector2(16, 0)
		$AnimatedSprite2D.play("Walk Right")
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2(-16, 0)
		$AnimatedSprite2D.play("Walk Left")
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2(0, -16)
		$AnimatedSprite2D.play("Walk Up")
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2(0, 16)
		$AnimatedSprite2D.play("Walk Down")
	
	if direction != Vector2.ZERO:
		targetPos = currPos + direction
		if !is_obstructed(targetPos):  
			move_to(targetPos)
		else:
			$AnimatedSprite2D.stop()  
	else:
		$AnimatedSprite2D.stop()  

func move_to(new_pos):
	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", new_pos, move_duration)
	tween.finished.connect(_on_tween_complete)
	currPos = new_pos

func _on_tween_complete():
	moving = false

func is_obstructed(target_pos: Vector2) -> bool:
	
	var original_layer_mask = collision_mask
	collision_mask &= ~(1 << water_collision_layer)  

	
	var direction = (target_pos - position).normalized()
	var collision = test_move(global_transform, direction * 16)

	# Restore the original collision mask
	collision_mask = original_layer_mask
	
	
	return collision
	
