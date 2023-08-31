extends Button

@export var collectible: collect_res = preload("res://ui/collectibles/journals/journal_1.tres")

func _ready():
	text = collectible.collect_display_name

func _on_pressed():
	get_parent().get_parent().get_parent().get_node("paragraph").text = collectible.collect_content
