extends CharacterBody2D

@export var movement_speed = 20.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")


func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
	if direction != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	velocity = direction * movement_speed
	move_and_slide()
	
