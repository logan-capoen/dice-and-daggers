extends Node2D

var hp = 100.0
var shield = 0.0
var damage_poison = 5.0

func die():
	set_process(false)
	set_physics_process(false)
	print("Game Over")

func take_damage(amount):
	var final_damage = amount
	if shield > 0:
		if shield >= final_damage:
			shield -= final_damage
			final_damage = 0
		else:
			final_damage -= shield
			shield = 0
	hp -= final_damage
	hp = max(hp, 0)
	if hp <= 0:
		die()

func add_poison(amount):
	damage_poison += amount

func add_shield(amount):
	shield += amount

func remove_shield(amount):
	shield -= amount
	shield = max(shield, 0)
