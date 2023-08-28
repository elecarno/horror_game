extends Control

func switch_item(item: String):
	print("switched to " + item)
	get_parent().visible = false
