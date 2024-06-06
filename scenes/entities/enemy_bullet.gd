extends Area2D

var speed: float = 0
var direction: Vector2 = Vector2.ZERO


func with_params(p_position: Vector2, p_speed: float,
	p_direction: Vector2):
	position = p_position
	speed = p_speed
	direction = p_direction.normalized()
	return self


func _ready():
	$AnimatedSprite2D.play()


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_area_entered(area):
	if area.get_collision_layer_value(2) and area.alive:
		area.die()
		queue_free()
