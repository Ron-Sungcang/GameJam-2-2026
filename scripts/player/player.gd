extends CharacterBody2D


const SPEED = 500.0
const FIRE_RATE = 0.5
const damage = 25
const KNOCKBACK_FORCE = 1000.0
const KNOCKBACK_FRICTION = 1500.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var bullet_speed = 2000
var bullet = preload("res://scenes/bullet.tscn")
var fire_timer = 0.0
var hp = 100
var knockback_velocity := Vector2.ZERO
var is_knocked_back := false


func _physics_process(delta: float) -> void:
	process_movement(delta)
	fire_timer -= delta
	if fire_timer <= 0:
		fire()
		fire_timer = FIRE_RATE
		
	move_and_slide()

func process_movement(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	look_at(get_global_mouse_position())

	if is_knocked_back:
		knockback_velocity = knockback_velocity.move_toward(
			Vector2.ZERO,
			KNOCKBACK_FRICTION * delta
		)
		velocity = knockback_velocity
		
		if knockback_velocity.length() < 10:
			knockback_velocity = Vector2.ZERO
			is_knocked_back = false

		return
	
	var direction := Input.get_vector("left","right","up","down")

	velocity = direction * SPEED
	
	play_animation(direction)
	if hp <= 0:
		get_tree().reload_current_scene()


func play_animation(dir: Vector2) -> void:
	if dir.x == 0 and dir.y == 0:
		animated_sprite_2d.play("idle")
	if dir.x != 0:
		animated_sprite_2d.flip_h = dir.x < 0
		animated_sprite_2d.play("walk_right")
	if dir.y < 0:
		animated_sprite_2d.play("walk_up")
	if dir.y > 0:
		animated_sprite_2d.play("walk_down")
		
func fire():
	var bullet_instance = bullet.instantiate()

	bullet_instance.global_position = global_position
	bullet_instance.global_rotation = global_rotation

	get_tree().current_scene.add_child(bullet_instance)

	var direction = Vector2.RIGHT.rotated(global_rotation)
	bullet_instance.apply_central_impulse(direction * bullet_speed)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.is_in_group("enemies"):
		print('Take damage')
		hp -= damage
		var knockback_direction = body.global_position.direction_to(global_position)
		knockback_velocity = knockback_direction * KNOCKBACK_FORCE
		is_knocked_back = true
		
