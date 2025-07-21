extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D

# MODIFIED: Renamed function to match the signal from the "Door" node.
func _on_Door_body_entered(body):
	# Only interact with the Player node.
	if body is Player:
		animated_sprite_2d.play()
		if body.has_method("stop_animations"):
			body.stop_animations()


# MODIFIED: Renamed function to match the signal from the "Door" node.
func _on_Door_body_exited(body):
	# Only interact with the Player node.
	if body is Player:
		animated_sprite_2d.play_backwards()
		if body.has_method("start_animations"):
			body.start_animations()
