extends Area2D

@onready var player: Player = get_parent()

func _on_body_entered(body: Node2D):
	# MODIFIED: Only interact with LootableItem nodes.
	if body is LootableItem:
		if player.has_method("stop_animations"):
			player.stop_animations()

func _on_body_exited(body: Node2D):
	# MODIFIED: Only interact with LootableItem nodes.
	if body is LootableItem:
		if player.has_method("start_animations"):
			player.start_animations()
