extends Node2D

# This function is called when the node and all its children enter the scene tree.
func _ready():
	# This line connects the global "fact_unlocked" signal from the EventBus
	# to the "display_fact" function on the FactPopup node.
	EventBus.fact_unlocked.connect($CanvasLayer/FactPopup.display_fact)
