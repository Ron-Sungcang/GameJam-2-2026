extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var player = get_parent().get_node("Player")
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	look_at(player.position)
	move_and_slide()
