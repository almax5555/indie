extends Resource
class_name Item

enum Rarity { COMMON, RARE, EPIC, LEGENDARY }

@export var name: String
@export var description: String
@export var rarity: Rarity = Rarity.COMMON
@export var effect: String = ""
