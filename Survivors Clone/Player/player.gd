extends CharacterBody2D

var movement_speed = 40.0
var hp = 80

# Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")

# AttackNodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 5
var icespear_attackspeed = 1.5
var icespear_level = 1

#Enemy Related
var enemy_close = []


@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

func _ready():
	attack()
	

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
 
func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
		


func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)
	print(damage)


func _on_ice_spear_timer_timeout() -> void:
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()

func _on_ice_spear_attack_timer_timeout() -> void:
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = _get_closest_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func comp_enemy_dist(enemy_a, enemy_b):
	if typeof(enemy_a) == typeof(enemy_b):
		var dist_a = (global_position - enemy_a.global_position).length()
		var dist_b = (global_position - enemy_b.global_position).length()
		return dist_a < dist_b 
	else:
		if typeof(enemy_a) == TYPE_STRING:
			return false
		else:
			return true

func _get_closest_target() -> Vector2:
	if enemy_close.size() == 0:
		return Vector2.UP
	var closest_distance = INF
	var closest_enemy
	for enemy in enemy_close:
		var distance = (global_position - enemy.global_position).length()
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy.global_position

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
