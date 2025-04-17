extends CharacterBody2D

@export var speed: float = 100.0
@export var damage: int = 10
@export var max_health: int = 20
@export var possible_drops: Array[Item]
@export var loot_scene: PackedScene

@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer

var current_health: int = max_health
var player: Node2D
var is_attacking: bool = false

signal enemy_killed

func _ready():
	player = get_tree().get_first_node_in_group("player")

func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		call_deferred("_on_death")

func _on_death() -> void:
	if player:
		player.gain_experience(10)

	if loot_scene and possible_drops.size() > 0:
		var loot = loot_scene.instantiate()
		get_tree().current_scene.add_child(loot)
		loot.global_position = global_position
		loot.item = possible_drops[randi() % possible_drops.size()]

	queue_free()
	emit_signal("enemy_killed")

func _physics_process(_delta: float) -> void:
	if not player:
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	if distance > 40:
		is_attacking = false
		velocity = to_player.normalized() * speed
		move_and_slide()
		if animation_player.animation != "Run":
			animation_player.play("Run")
	else:
		velocity = Vector2.ZERO
		move_and_slide()

		if not is_attacking:
			is_attacking = true
			animation_player.play("Attack")
			attack_timer.start()

func _on_AttackTimer_timeout() -> void:
	if player and global_position.distance_to(player.global_position) < 30:
		player.take_damage(damage)
	is_attacking = false
