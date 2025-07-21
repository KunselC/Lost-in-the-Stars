class_name Player
extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@export var inventory: Inventory
var walk_animation_template = "player/walk_%s"

var speed = 100
var equipped_item: Item = null # This will hold the currently selected item.

func _ready():
    # Add the player to the "player" group so other nodes can find it.
    add_to_group("player")

    # Give the player seeds at the start.
    var starting_seeds = load("res://Resources/corn_seeds.tres")
    if starting_seeds and inventory:
        inventory.add_item(starting_seeds)

func equip_item(item: Item):
    equipped_item = item
    # You could add logic here to change the mouse cursor, for example.
    print("Equipped: ", equipped_item.name if equipped_item else "Nothing")

func _process(_delta):
    velocity = Focus.input_get_vector("move_left", "move_right", "move_up", "move_down") * speed
    move_and_slide()
    
    if Focus.input_is_action_pressed("move_up"):
        animation_player.play(walk_animation_template % "up")
    elif Focus.input_is_action_pressed("move_down"):
        animation_player.play(walk_animation_template % "down")
    elif Focus.input_is_action_pressed("move_left"):
        animation_player.play(walk_animation_template % "left")
    elif Focus.input_is_action_pressed("move_right"):
        animation_player.play(walk_animation_template % "right")
    else:
        # MODIFIED: Play an idle animation instead of stopping the player.
        animation_player.play("player/idle")
