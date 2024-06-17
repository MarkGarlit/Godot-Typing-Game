extends Node2D

var Enemy = preload("res://enemy.tscn")


@onready var enemy_container = $EnemyContainer
@onready var spawn_container = $SpawnerContainer
@onready var spawn_timer = $SpawnTimer


var active_enemy = null
var current_letter_index = -1


func _ready() -> void:
	randomize()
	spawn_timer.start()
	spawn_enemy()
	


func find_new_active_enemy(typed_character: String):
	for enemy in enemy_container.get_children():
		var prompt = enemy.get_prompt()
		var next_character = prompt.substr(0,1)
		if prompt.substr(0,1) == typed_character:
			print("Found new enemy that starts with %s" % next_character)
			active_enemy = enemy
			current_letter_index = 1
			active_enemy.set_next_character(current_letter_index)
			return
		


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():	
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		
		if active_enemy == null:
			find_new_active_enemy(key_typed)
		else:
			var prompt = active_enemy.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)
			if key_typed == next_character:
				print("Successfully typed %s" % key_typed)
				current_letter_index += 1
				active_enemy.set_next_character(current_letter_index)
				if current_letter_index == prompt.length():
					print("Done")
					current_letter_index = -1
					active_enemy.queue_free()
					active_enemy = null
			else:
				print("Incorrectly typed %s instead of %s" % [key_typed, next_character])
	
	


func _on_spawn_timer_timeout():
	spawn_enemy()
	
func spawn_enemy():
	var enemy_instance = Enemy.instantiate()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawns[index].global_position

##Test Push 
