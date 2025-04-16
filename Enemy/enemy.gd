extends CharacterBody2D

@export var speed: float = 100.0
@export var damage: int = 10
@export var max_health := 20
@export var possible_drops: Array[Item]
@export var loot_scene: PackedScene

var current_health := max_health
var player: Node2D

signal enemy_killed

func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		call_deferred("_on_death")  # Важно: вызываем через call_deferred


func _on_death() -> void:
	player = get_tree().get_first_node_in_group("player")

	if player:
		player.gain_experience(10)

	if loot_scene and possible_drops.size() > 0:
		var loot = loot_scene.instantiate()
		get_tree().current_scene.add_child(loot)
		loot.global_position = global_position

		var dropped_item = possible_drops[randi() % possible_drops.size()]
		loot.item = dropped_item

	queue_free()
	emit_signal("enemy_killed")


func _physics_process(_delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
