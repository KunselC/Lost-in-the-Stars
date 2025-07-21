extends Control

@onready var label: Label = $PanelContainer/Label
# FIX: Declare the timer variable, but don't assign it here.
var timer: Timer

func _ready():
    # The popup should start invisible.
    visible = false
    
    # Create a Timer node via code.
    var new_timer = Timer.new()
    new_timer.name = "Timer"
    new_timer.wait_time = 5.0
    new_timer.one_shot = true
    
    # Connect the timer's "timeout" signal to this script's "hide" function.
    new_timer.timeout.connect(hide)
    
    # Add the timer to the scene.
    add_child(new_timer)
    
    # Assign it to our class variable.
    timer = new_timer


# This is the function that other parts of our game will call.
func display_fact(fact_text: String):
    # Set the text and make the popup visible.
    label.text = fact_text
    visible = true
    # Start the 5-second countdown.
    timer.start()