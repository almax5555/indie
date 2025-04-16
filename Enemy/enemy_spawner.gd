extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 2.0

var timer := 0.0

func _process(delta):
	timer += delta
	if timer >= spawn_interval:
		timer = 0
		spawn_enemy()

func spawn_enemy():
	if not enemy_scene:
		return

	var enemy = enemy_scene.instantiate()
	var player = get_tree().get_first_node_in_group("player")

	if player and enemy:
		add_child(enemy)
		enemy.global_position = get_random_spawn_position()
		enemy.player = player

func get_random_spawn_position() -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var x = randf_range(0, screen_size.x)
	var y = randf_range(0, screen_size.y)
	return Vector2(x, y)
