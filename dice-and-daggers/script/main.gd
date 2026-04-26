extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var fade_rect = $GameOverLayer/FadeRect
@onready var spawn_point: Marker2D = $BossSpawnPoint
@export var boss_scenes: Array[PackedScene]

var current_boss: Node2D = null
var dernier_nom: String = ""
var combo_actuel: int = 0
var multiplicateurs = [1.0, 1.5, 2.0, 4.0, 8.0, 16.0, 32.0]

func _ready():
	var tous_les_des = get_tree().get_nodes_in_group("dés")
	for de in tous_les_des:
		de.hide()
		de.est_utilise = true
	
	spawn_random_boss()

func spawn_random_boss() -> void:
	if boss_scenes.is_empty():
		print("Erreur : La liste de boss est vide dans l'inspecteur !")
		return
		
	var random_boss_scene = boss_scenes.pick_random()
	current_boss = random_boss_scene.instantiate()
	current_boss.add_to_group("boss")
	current_boss.global_position = spawn_point.global_position
	add_child(current_boss)
	
	current_boss.on_boss_died.connect(_on_boss_died)
	if current_boss.has_signal("on_boss_attacked"):
		current_boss.on_boss_attacked.connect(_on_boss_attacked)
	
	print("Un nouveau boss apparaît !")

func _on_boss_attacked(degats):
	if player:
		player.take_damage(degats)
		if player.hp <= 0:
			game_over()
			
func game_over():
	print("GAME OVER")
		
	if fade_rect:
		var tween = create_tween()
		tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)
		
		await tween.finished
		await get_tree().create_timer(0.5).timeout
	
	get_tree().reload_current_scene()

func _on_boss_died():
	print("Boss mort. Préparation du suivant...")
	
	await get_tree().create_timer(2.0).timeout
	
	if current_boss != null:
		current_boss.queue_free()
		
	spawn_random_boss()

func gerer_clic_de(de_clique: Area2D, nom_image: String):
	if nom_image == dernier_nom:
		combo_actuel += 1
	else:
		combo_actuel = 0
	combo_actuel = min(combo_actuel, multiplicateurs.size() - 1)
	dernier_nom = nom_image
	var m = multiplicateurs[combo_actuel]
	de_clique.afficher_texte_combo(m)
	appliquer_effet_global(nom_image, m)

func appliquer_effet_global(nom, multi):
	match nom:
		"sword":
			if current_boss:
				current_boss.hurt(int(10 * multi))
		"skull":
			if current_boss:
				current_boss.hurt(int(20 * multi))
		"heart":
			if player:
				player.hp = min(player.hp + int(10 * multi), 100)
		"shield":
			if player:
				player.add_shield(int(5 * multi))

func _on_button_pressed():
	var tous_les_des = get_tree().get_nodes_in_group("dés")
	
	if not tous_les_des[0].visible:
		print("Premier lancer de la partie !")
		for de in tous_les_des:
			de.show()
			de.est_utilise = false
			de.lancer_animation()
		return

	for de in tous_les_des:
		if not de.est_utilise:
			print("Utilise tous les dés d'abord !")
			return
	
	dernier_nom = ""
	combo_actuel = 0
	for de in tous_les_des:
		de.est_utilise = false
		de.sprite.self_modulate = Color(1, 1, 1)
		de.lancer_animation()
	
	if current_boss:
		current_boss.attack1()
