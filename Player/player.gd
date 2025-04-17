extends CharacterBody2D

@export var bullet_scene: PackedScene
@export var speed: float = 500.0
@export var weapon: Weapon
@onready var shoot_timer: Timer = $ShootTimer


var level := 1
var experience := 0
var experience_to_next := 20
var inventory: Array[Item] = []
var can_shoot := true
var last_direction = Vector2.RIGHT
var current_weapon: Weapon


@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func collect_item(item: Item):
	inventory.append(item)
	print("Picked up: %s (%s)" % [item.name, item.rarity])

func gain_experience(amount):
	experience += amount
	if experience >= experience_to_next:
		level_up()

func level_up():
	level += 1
	experience -= experience_to_next
	experience_to_next = int(experience_to_next * 1.5)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if can_shoot:
			shoot()

func _physics_process(_delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	velocity = direction.normalized() * speed
	move_and_slide()

	# Анимация
	if direction == Vector2.ZERO:
		if anim.animation != "Stay":
			anim.play("Stay")
	else:
		if anim.animation != "Run":
			anim.play("Run")

func shoot():
	var nearest_enemy = find_nearest_enemy()
	if nearest_enemy:
		current_weapon.shoot(global_position, nearest_enemy.global_position, self)

func find_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	var nearest = null
	var min_distance = INF
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			nearest = enemy
	return nearest

func _ready():
	if current_weapon:
		$ShootTimer.wait_time = 1.0 / current_weapon.fire_rate
		$ShootTimer.start()
	
func _on_ShootTimer_timeout():
	var closest_enemy = get_closest_enemy()
	if closest_enemy:
		weapon.shoot(global_position, closest_enemy.global_position, self)
		
func get_closest_enemy() -> Node2D:
	var closest = null
	var min_dist = INF
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var dist = global_position.distance_to(enemy.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = enemy
	return closest


func _on_shoot_timer_ready() -> void:
	pass # Replace with function body.
