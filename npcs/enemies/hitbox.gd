class_name hitbox
extends Area2D

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	
func _on_area_entered(hurtbox: hurtbox) -> void:
	if hurtbox == null:
		return
		
	if owner.has_method("reset_state"):
		owner.reset_state()
