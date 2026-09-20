extends CharacterBody2D

const SPEED = 300.0

var target = null
var health: int = 100

func _physics_process(delta: float) -> void:
	if target != null:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * SPEED
		look_at(target.global_position)
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func take_damage(damage: int) -> void:
	health -= damage
	print(health)
	if health <= 0:
		die()

func die() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets"):
		print("Damage enemy")
		take_damage(body.damage)
		body.add_collision_exception_with(self)
		target = get_parent().get_node("Player")


func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player detecteds")
		target = body
