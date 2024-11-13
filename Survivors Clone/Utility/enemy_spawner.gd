extends Node2D

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

var time = 0


func _on_timer_timeout() -> void:
	time += 1
	var enemy_spawns = spawns
	for wave in enemy_spawns:
		if time >= wave.time_start and time <= wave.time_end:
			if wave.spawn_delay_counter < wave.enemy_spawn_delay:
				wave.spawn_delay_counter += 1
			else:
				wave.spawn_delay_counter = 0
				var new_enemy = wave.enemy
				var counter = 0
				while counter < wave.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					var enemy_position = get_random_position()
					enemy_spawn.set_global_position(enemy_position)
					add_child(enemy_spawn)
					counter += 1

func get_random_position():
	var vpr = get_viewport_rect().end
	var play_pos = player.get_global_position()
	var radius = Vector2.ZERO.distance_to(vpr) * randf_range(1.05,1.2)
	var angle = randf_range(0, 2 * PI)
	return Vector2(radius,0).rotated(angle)
