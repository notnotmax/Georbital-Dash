extends Area2D
@export var Bullet : PackedScene
signal player_died

var alive: bool = true
var is_firing: bool = false
# cooldown timer before next shot
var shot_cooldown = 0
# shoot every (fire_rate / 60) seconds
var fire_rate = 6


# Called when the node enters the scene tree for the first time.
func _ready():
	# Lock the cursor to the center of the screen and hide it
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# placeholder starting position
	position.x = 100
	position.y = 360
	$AnimatedSprite2D.play("default")


func _physics_process(_delta):
	if alive:
		# decrease shooting cooldown
		if shot_cooldown > 0:
			shot_cooldown -= 1
		# shoot
		if shot_cooldown <= 0:
			if is_firing:
				var bullet = Bullet.instantiate().with_params(
					$Marker2D.global_position,
					20,
					Vector2(1, 0),
					10
				)
				get_tree().current_scene.add_child(bullet)
			shot_cooldown += fire_rate


func _input(event):
	if alive:
		# Player movement
		if event is InputEventMouseMotion:
			position += event.relative
			position.x = clamp(position.x, 16, get_viewport_rect().size.x - 24)
			position.y = clamp(position.y, 16, get_viewport_rect().size.y - 16)
			# change movement sprite
			if event.relative.y >= 3:
				$AnimatedSprite2D.play("moving_down_fast")
			elif event.relative.y >= 1:
				$AnimatedSprite2D.play("moving_down_slow")
			elif event.relative.y >= -1:
				$AnimatedSprite2D.play("default")
			elif event.relative.y >= -3:
				$AnimatedSprite2D.play("moving_up_slow")
			else:
				$AnimatedSprite2D.play("moving_up_fast")
		
		# toggle fire mode
		elif event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				is_firing = event.pressed


# for picking up things like powerups/effects only
# death collision is handled by the enemy instance
func _on_area_entered(_area):
	pass


func _on_animated_sprite_2d_animation_finished():
	if !alive:
		player_died.emit()
		queue_free()


# enemy instances call this upon collision with player to kill them
func die():
	if alive:
		alive = false
		$AnimatedSprite2D.play("death")
