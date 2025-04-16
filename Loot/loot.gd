extends Area2D

@export var item: Item

func _ready():
	# Если предмет уже установлен в редакторе — сразу применяем визуал
	if item != null:
		apply_rarity_color()


func apply_rarity_color() -> void:
	match item.rarity:
		Item.Rarity.COMMON:
			modulate = Color.WHITE
		Item.Rarity.RARE:
			modulate = Color.BLUE
		Item.Rarity.EPIC:
			modulate = Color.MAGENTA
		Item.Rarity.LEGENDARY:
			modulate = Color.ORANGE


func _on_Loot_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.collect_item(item)
		queue_free()
