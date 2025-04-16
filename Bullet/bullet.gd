extends Area2D

@export var speed: float = 600.0
@export var damage: int = 10
var direction = Vector2.ZERO

func _physics_process(delta):
	position += direction * speed * delta

func _on_Bullet_body_entered(body):
	print("Bullet hit something:", body)
	if body.has_method("take_damage"):
		print("It has take_damage")
		body.take_damage(damage)
	else:
		print("No take_damage found")
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
