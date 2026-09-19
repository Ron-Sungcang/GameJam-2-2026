extends CharacterBody2D


const SPEED = 500.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var bullet_speed = 2000
var bullet = preload("res://scenes/bullet.tscn")

func _physics_process(delta: float) -> void:
	process_movement()
	move_and_slide()

func process_movement() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left","right","up","down")

	velocity = direction * SPEED
	look_at(get_global_mouse_position())
	
	play_animation(direction)
	
	if Input.is_action_just_pressed("fire"):
		fire()


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
	get_tree().root.add_child(bullet_instance)
	var direction = Vector2.RIGHT.rotated(global_rotation)
	bullet_instance.apply_central_impulse(direction * bullet_speed)
