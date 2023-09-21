class_name ui
extends CanvasLayer

@onready var world_con: world_controller = get_parent()
@onready var playerdata_con: playerdata_controller = get_parent().get_node("playerdata_con")
@onready var journal_button: PackedScene = preload("res://ui/collectibles/journal_button.tscn")

var using_watch: bool = false

func _process(_delta):
	if Input.is_action_just_pressed("notebook"):
		toggle_notebook()
		
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()
		
	if Input.is_action_just_pressed("watch"):
		using_watch = true
		get_node("control/watch/watch_open").playing = true
	if Input.is_action_just_released("watch"):
		using_watch = false
		get_node("control/watch/watch_close").playing = true
		
	if using_watch:
		get_node("control/watch").visible = true
		watch_update()
	else:
		get_node("control/watch").visible = false

func watch_update():
	get_node("control/watch/minute_hand").rotation_degrees = (360/60) * world_con.minute_ref
	get_node("control/watch/hour_hand").rotation = (((2 * PI) / 12) * world_con.hour_ref) + (((2 * PI) / 720) * world_con.minute_ref)

func toggle_inventory():
	if get_node("control/lootables").visible:
		get_node("control/lootables").visible = false
	else:
		get_node("control/inventory").visible = !get_node("control/inventory").visible
		playerdata_con.pouch_1.update_pouch()
		playerdata_con.pouch_2.update_pouch()
		playerdata_con.pouch_3.update_pouch()

func toggle_notebook():
	playerdata.sort_collected_arrays()
	get_node("control/notebook").visible = !get_node("control/notebook").visible
	get_node("control/notebook/day_counter").text = "Day #" + str(world_con.day_ref)
	get_node("control/notebook/journals_counter").text = "Journals: " + str(playerdata.collected_journals.size()) + "/" + str(playerdata.journals.size())
	get_node("control/notebook/notes_counter").text = "Notes: " + str(playerdata.collected_notes.size()) + "/" + str(playerdata.notes.size())

func _on_minute_tick_timer_timeout():
	if using_watch:
		get_node("control/watch/minute_tick").playing = true


func _on_journals_counter_pressed():
	get_node("control/notebook/journals_container").visible = !get_node("control/notebook/journals_container").visible
	get_node("control/notebook/notes_container").visible = false
	var container = get_node("control/notebook/journals_container/vbox")
	for i in container.get_children():
		i.queue_free()
		
	for i in range(0, playerdata.collected_journals.size()):
		var journal_button_instance = journal_button.instantiate()
		journal_button_instance.collectible = load(playerdata.journals_path + playerdata.journals[playerdata.collected_journals[i]])
		container.add_child(journal_button_instance)

func _on_notes_counter_pressed():
	get_node("control/notebook/notes_container").visible = !get_node("control/notebook/notes_container").visible
	get_node("control/notebook/journals_container").visible = false
	var container = get_node("control/notebook/notes_container/vbox")
	for i in container.get_children():
		i.queue_free()
		
	for i in range(0, playerdata.collected_notes.size()):
		var journal_button_instance = journal_button.instantiate()
		journal_button_instance.collectible = load(playerdata.notes_path + playerdata.notes[playerdata.collected_notes[i]])
		container.add_child(journal_button_instance)
