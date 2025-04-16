extends CharacterBody2D

@export var bullet_scene: PackedScene
@export var speed: float = 500.0

var level := 1
var experience := 0
var experience_to_next := 20
var inventory: Array[Item] = []

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
	print("Level Up! Now level %d" % level)
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
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
	


func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		var mouse_pos = get_global_mouse_position()
		bullet.direction = (mouse_pos - global_position).normalized()
