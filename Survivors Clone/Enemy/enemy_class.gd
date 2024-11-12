class_name Enemy_Body

extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10.0
@export var armor = 0


func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= clampi(damage - armor, 1, 9999)
	if hp <= 0:
		queue_free()
