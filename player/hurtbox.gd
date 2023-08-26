class_name hurtbox
extends Area2D

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	
func _on_area_entered(hitbox: hitbox) -> void:
	if hitbox == null:
		return
	if owner.has_method("take_damage"):
		owner.take_damage()
