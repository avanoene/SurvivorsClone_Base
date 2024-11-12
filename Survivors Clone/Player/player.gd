extends CharacterBody2D

var hp = 80

var movement_speed = 40.0
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# delta is 1 second / framerate
	movement()

func movement() -> void:
	var mov_vect = Input.get_vector("left", "right", "up", "down").normalized() # get the input direction in a vector
	if mov_vect.x > 0:
		sprite.flip_h = true
	elif mov_vect.x < 0:
		sprite.flip_h = false
	if mov_vect != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
			
	velocity = mov_vect * movement_speed # normalized vector mult by how many pixels per frame
	move_and_slide() #built in func 
 


func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)
	print(damage)
