extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var player = get_parent().get_node("Player")
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	look_at(player.position)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		print("Damage enemy")
