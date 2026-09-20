extends CharacterBody2D

const SPEED = 300.0

var target = null

func _physics_process(delta: float) -> void:
	if target != null:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * SPEED
		look_at(target.global_position)
		move_and_slide()
	else:
		velocity = Vector2.ZERO


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		print("Damage enemy")


func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player detecteds")
		target = body
