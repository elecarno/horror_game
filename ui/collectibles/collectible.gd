extends TextureButton

var contained_collectible: String = "journal_1.tres"

func _on_pressed():
	for i in range(playerdata.journals.size()):
		if playerdata.journals[i] == contained_collectible and !playerdata.collected_journals.has(i):
			playerdata.collected_journals.append(i)
	for i in range(playerdata.notes.size()):
		if playerdata.notes[i] == contained_collectible and !playerdata.collected_notes.has(i):
			playerdata.collected_notes.append(i)
			
	queue_free()
