class_name EncyclopediaData
extends Resource

signal fact_added(fact_text: String)

@export var unlocked_facts: Array[String]

func add_fact(fact: String):
    if not unlocked_facts.has(fact):
        unlocked_facts.append(fact)
        fact_added.emit(fact)
        print("New fact unlocked: ", fact)