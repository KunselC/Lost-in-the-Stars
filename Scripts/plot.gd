class_name Plot
extends StaticBody2D

@export var sprite: Sprite2D

var planted_crop: Crop 
var current_growth_phase: Global.GrowthPhase
var is_planted: bool = false

# REMOVED: The test_seed_to_plant variable is no longer needed.

func _ready():
    %WorldClock.clock_progress.connect(handle_hourly_growth)
    update_sprite()


func handle_hourly_growth(day, hour):	
    if is_planted and not is_harvestable():
        if hour > 0 and hour % 12 == 0:
            advance_growth_phase()

# MODIFIED: The plant function now accepts an Item resource.
func plant(seed_item: Item):
    # Check if the plot is empty and if the provided item is a valid seed.
    if not is_planted and seed_item and seed_item.seed_grows_into:
        # Get the Crop resource from the seed item's 'seed_grows_into' property.
        var crop_to_plant = seed_item.seed_grows_into
        
        planted_crop = crop_to_plant.duplicate()
        is_planted = true
        current_growth_phase = Global.GrowthPhase.GERMINATING
        update_sprite()
        
        # Return true to indicate planting was successful.
        return true
    
    # Return false if planting failed (e.g., plot was not empty or item was not a seed).
    return false


func advance_growth_phase():
    if current_growth_phase < Global.GrowthPhase.MATURE:
        current_growth_phase += 1
        update_sprite()
        
        if planted_crop and not planted_crop.crop_facts.is_empty():
            var random_fact = planted_crop.crop_facts.pick_random()
            EventBus.fact_unlocked.emit(random_fact)


func is_harvestable() -> bool:
    return is_planted and current_growth_phase == Global.GrowthPhase.MATURE


func update_sprite():
    if is_planted:
        sprite.texture = planted_crop.get_texture_for_phase(current_growth_phase)
    else:
        sprite.texture = null

# MODIFIED: This function now completes the planting interaction.
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
    if Focus.event_is_action_pressed(event, &"select"):
        if is_harvestable():
            harvest()
            Input.set_custom_mouse_cursor(Global.RESOURCES.CURSOR.DEFAULT)
        elif not is_planted:
            var player: Player = get_tree().get_first_node_in_group("player")
            if player and player.equipped_item:
                if plant(player.equipped_item):
                    # ADD THIS LINE to remove the seed after planting.
                    player.inventory.remove_item(player.equipped_item)


func harvest():
    if is_harvestable():
        var loot = Global.RESOURCES.NODE.LOOTABLE_ITEM.instantiate()
        loot.item = planted_crop.harvest
        loot.position = position
        get_parent().add_child(loot)
        
        is_planted = false
        planted_crop = null
        update_sprite()


func _mouse_shape_enter(shape_idx: int):
    if is_harvestable():
        Input.set_custom_mouse_cursor(Global.RESOURCES.CURSOR.HARVEST)
    
func _mouse_shape_exit(shape_idx: int):
    Input.set_custom_mouse_cursor(Global.RESOURCES.CURSOR.DEFAULT)