extends Area2D

@export var speed: float = 600.0
@export var damage: int = 10
var direction = Vector2.ZERO

@onready var anim = $AnimatedSprite2D

func set_direction(dir: Vector2):
	direction = dir.normalized()
	
	if abs(direction.x) > abs(direction.y):
		# Горизонтальное движение — зеркалим по X
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		# Вертикальное движение — можно добавить flip_v или оставить
		$AnimatedSprite2D.flip_v = direction.y < 0

func _ready():
	$AnimatedSprite2D.play("fireball")
	
func _physics_process(delta):
	position += direction * speed * delta

func _on_Bullet_body_entered(body):
	print("Bullet hit something:", body)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
