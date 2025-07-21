class_name Crop
extends Resource

@export var harvest: Item
@export var texture_resource: MappedTexture
@export var crop_facts: Array[String]

@export_group("Germination Phase", "germination_")
@export_range(.5, 4, .5, "suffix:days") var germination_duration := 0.5

@export_group("Budding Phase", "budding_")
@export_range(.5, 4, .5, "suffix:days") var budding_duration := 0.5

@export_group("Flowering Phase", "flowering_")
@export_range(.5, 4, .5, "suffix:days") var flowering_duration := 0.5

@export_group("Maturation Phase", "maturation_")
@export_range(.5, 4, .5, "suffix:days") var maturation_duration := 0.5


# This function gets the correct texture based on the growth phase.
# This is the function that was missing.
func get_texture_for_phase(phase: Global.GrowthPhase) -> AtlasTexture:
    if texture_resource:
        return texture_resource.clip_texture(texture_resource.texture_frame + phase)
    return null