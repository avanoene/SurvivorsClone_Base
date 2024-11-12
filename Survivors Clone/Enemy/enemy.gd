extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var anim = $walkAnimation

func _ready() -> void:
	anim.play("walk")

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false
	velocity = direction * movement_speed
	move_and_slide()
	


func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	if hp <= 0:
		queue_free()
