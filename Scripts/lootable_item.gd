class_name LootableItem
extends StaticBody2D

@export var item: Item

@onready var sprite: Sprite2D = $Sprite2D
@onready var loot_range: Area2D = $LootRange

func _ready():
    if item:
        sprite.texture = item.texture
    loot_range.body_entered.connect(handle_body_entered)

func handle_body_entered(body: Node2D):
    if body is Player:
        var player: Player = body
        if player.inventory.add_item(item):
            queue_free()