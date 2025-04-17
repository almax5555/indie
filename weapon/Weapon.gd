extends Resource
class_name Weapon

@export var fire_rate: float = 1.0        # Выстрелы в секунду
@export var damage: int = 10              # Урон за пулю
@export var bullet_count: int = 1         # Количество пуль за выстрел
@export var spread_degrees: float = 0.0   # Разброс пуль (в градусах)
@export var bullet_scene: PackedScene     # Пуля

func shoot(from_position: Vector2, target_position: Vector2, owner: Node2D):
	var direction = (target_position - from_position).normalized()
	for i in bullet_count:
		var angle_offset = deg_to_rad(spread_degrees) * (i - float(bullet_count - 1) / 2)

		var final_direction = direction.rotated(angle_offset)
		var bullet = bullet_scene.instantiate()
		bullet.global_position = from_position
		bullet.direction = final_direction
		bullet.damage = damage
		bullet.owner = owner
		owner.get_tree().current_scene.add_child(bullet)
