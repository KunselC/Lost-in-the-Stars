class_name LootableItem
extends StaticBody2D

@export var item: Item

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
    if item:
        sprite.texture = item.texture