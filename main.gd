extends Node2D

@export var encyclopedia_data: EncyclopediaData

# This must match the name of the CanvasLayer node in your main.tscn
@onready var canvas_layer = $CanvasLayer2
@onready var encyclopedia_ui_instance = preload("res://Scenes/encyclopedia_ui.tscn").instantiate()

func _ready():
    # Connect the global event to our data resource
    if encyclopedia_data:
        EventBus.fact_unlocked.connect(encyclopedia_data.add_fact)
    
    # This is the critical part:
    # Add the encyclopedia UI to the CanvasLayer, NOT to the main scene.
    canvas_layer.add_child(encyclopedia_ui_instance)

func _input(event):
    if event.is_action_pressed("open_encyclopedia"):
        encyclopedia_ui_instance.open()