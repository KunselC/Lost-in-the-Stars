class_name Item
extends Resource

@export var name: String
@export var texture: Texture2D
@export var stackable := true
@export var seed_grows_into: Crop # Add this line

func _to_string():
    return "Item: %s" % name