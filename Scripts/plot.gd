class_name Plot
extends StaticBody2D

@export var sprite: Sprite2D

# This will hold the unique instance of the crop planted here. It starts as null.
var planted_crop: Crop 
# This variable will hold the current growth phase for the crop in this plot.
var current_growth_phase: Global.GrowthPhase

var is_planted: bool = false

# For testing, we can assign a crop resource in the editor to plant on click.
@export var test_seed_to_plant: Crop


func _ready():
    %WorldClock.clock_progress.connect(handle_hourly_growth)
    update_sprite() # Initially show an empty plot


func handle_hourly_growth(day, hour):	
    if is_planted and not is_harvestable():
        # This simple logic advances the phase every 12 hours.
        # You can later expand this to use the duration properties from your Crop resource.
        if hour % 12 == 0:
            advance_growth_phase()


func plant(seed_resource: Crop):
    if not is_planted and seed_resource != null:
        # Duplicate the resource to create a unique instance for this plot
        planted_crop = seed_resource.duplicate()
        is_planted = true
        current_growth_phase = Global.GrowthPhase.GERMINATING
        update_sprite()


func advance_growth_phase():
    if current_growth_phase < Global.GrowthPhase.MATURE:
        current_growth_phase += 1
        update_sprite()


func is_harvestable() -> bool:
    return is_planted and current_growth_phase == Global.GrowthPhase.MATURE


func update_sprite():
    if is_planted:
        sprite.texture = planted_crop.get_texture_for_phase(current_growth_phase)
    else:
        # When not planted, the plot is empty.
        sprite.texture = null


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
    if Focus.event_is_action_pressed(event, &"select"):
        if is_harvestable():
            harvest()
            Input.set_custom_mouse_cursor(Global.RESOURCES.CURSOR.DEFAULT)
        elif not is_planted:
            # If the plot is empty, plant our test seed.
            plant(test_seed_to_plant)


func harvest():
    if is_harvestable():
        var loot = Global.RESOURCES.NODE.LOOTABLE_ITEM.instantiate()
        loot.item = planted_crop.harvest
        loot.position = position
        get_parent().add_child(loot)
        
        # CRITICAL CHANGE: Reset the plot instead of deleting it.
        is_planted = false
        planted_crop = null
        update_sprite()


func _mouse_shape_enter(shape_idx: int):
    if is_harvestable():
        Input.set_custom_mouse_cursor(Global.RESOURCES.CURSOR.HARVEST)
    
func _mouse_shape_exit(shape_idx: int):
    Input.set_custom_mouse_cursor(Global.RESOURCES.CURSOR.DEFAULT)