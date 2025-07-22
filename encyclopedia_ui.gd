extends Control

@export var encyclopedia_data: EncyclopediaData

# MODIFIED: Use a direct path to the FactList container.
@onready var fact_list: VBoxContainer = $VBoxContainer/ScrollContainer/FactList
@onready var close_button: Button = $VBoxContainer/Button

func _ready():
	close_button.pressed.connect(hide)
	if encyclopedia_data:
		encyclopedia_data.fact_added.connect(add_fact_label)
	
	# Hide by default
	hide()

func open():
	# Clear existing facts and rebuild the list
	for child in fact_list.get_children():
		child.queue_free()
	
	if encyclopedia_data:
		for fact_text in encyclopedia_data.unlocked_facts:
			add_fact_label(fact_text)
	
	show()

func add_fact_label(fact_text: String):
	var label = Label.new()
	label.text = "- " + fact_text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	fact_list.add_child(label)
