extends Node

var journals: Array
var collected_journals: Array = [0, 2, 1]
var journals_path: String = "res://ui/collectibles/journals/" 

var notes: Array
var collected_notes: Array = [0]
var notes_path: String = "res://ui/collectibles/notes/" 

func _ready():
	journals = _collect_resources(journals_path)
	notes = _collect_resources(notes_path)
	print(journals)
	print(notes)

func _collect_resources(dir_path: String):
	var dir = DirAccess.open(dir_path)
	var files = []
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
			
	dir.list_dir_end()
	
	return files
