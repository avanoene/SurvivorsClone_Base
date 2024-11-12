extends Enemy_Body

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
	
