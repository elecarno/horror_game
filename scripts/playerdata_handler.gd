extends Node

var journals: Array
var collected_journals: Array = []
var journals_path: String = "res://ui/collectibles/journals/" 

var notes: Array
var collected_notes: Array = []
var notes_path: String = "res://ui/collectibles/notes/"

func _ready():
	journals = _collect_resources(journals_path)
	notes = _collect_resources(notes_path)
	print(journals)
	print(notes)

# creates array based on files in `dir_path`
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
	
func sort_collected_arrays():
	collected_journals.sort()
	collected_notes.sort()
	
func check_for_completion(type: String):
	sort_collected_arrays()
	if type == "journals":
		if collected_journals.size() == journals.size():
			return true
		else:
			return false
	if type == "notes":
		if collected_notes.size() == notes.size():
			return true
		else:
			return false

func get_random_collectible():
	randomize()
	var type_number = randi_range(0, 100) # use (0, 2) when adding items
	var type_array: Array
	var collected_type_array: Array
	if type_number <= 75:
		if !playerdata.check_for_completion("journals"):
			type_array = playerdata.journals
			collected_type_array = playerdata.collected_journals
		else:
			type_array = playerdata.notes
			collected_type_array = playerdata.collected_notes
	elif type_number >= 75:
		if !playerdata.check_for_completion("notes"):
			type_array = playerdata.notes
			collected_type_array = playerdata.collected_notes
		else:
			type_array = playerdata.journals
			collected_type_array = playerdata.collected_journals
		
	var cleared_type_array: Array
	for i in range(0, type_array.size()):
		if !collected_type_array.has(i):
			cleared_type_array.append(type_array[i])
	
#	print(type_array)
#	print(cleared_type_array)
	return cleared_type_array[randi() % cleared_type_array.size()]
