extends Node2D

@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var fade_rect = $GameOverLayer/FadeRect

var dernier_nom: String = ""
var combo_actuel: int = 0
var multiplicateurs = [1.0, 1.5, 2.0, 4.0, 8.0, 16.0, 32.0]

func _on_boss_attacked(degats):
	if player:
		player.take_damage(degats)
		# ON VÉRIFIE LA MORT DU JOUEUR APRÈS CHAQUE ATTAQUE DU BOSS
		if player.hp <= 0:
			game_over()
			
func game_over():
	print("GAME OVER")
		
	if fade_rect:
		# Création du Tween pour le fondu au noir
		var tween = create_tween()
		# On fait passer l'alpha de 0 à 1 en 1 seconde
		tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)
		
		# On attend que le fondu soit fini (plus un petit délai)
		await tween.finished
		await get_tree().create_timer(0.5).timeout
	
	# On recommence la partie
	get_tree().reload_current_scene()

func _on_boss_died():
	print("Boss mort")

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
			if boss:
				boss.hurt(int(10 * multi))
		"skull":
			if boss:
				boss.hurt(int(20 * multi))
		"heart":
			if player:
				player.hp = min(player.hp + int(10 * multi), 100)
		"shield":
			if player:
				player.add_shield(int(5 * multi))

func _ready():
	# Cache tous les dés au lancement du jeu
	var tous_les_des = get_tree().get_nodes_in_group("dés")
	for de in tous_les_des:
		de.hide()
		de.est_utilise = true # On les "verrouille" pour ne pas cliquer dans le vide
	
	if boss == null: return
	boss.on_boss_attacked.connect(_on_boss_attacked)
	boss.on_boss_died.connect(_on_boss_died)

func _on_button_pressed():
	var tous_les_des = get_tree().get_nodes_in_group("dés")
	
	# --- LOGIQUE DU PREMIER LANCER (Si les dés sont cachés) ---
	if not tous_les_des[0].visible:
		print("Premier lancer de la partie !")
		for de in tous_les_des:
			de.show()
			de.est_utilise = false
			de.lancer_animation()
		return # On sort de la fonction ici

	# --- LOGIQUE DE RELANCE HABITUELLE ---
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
	
	if boss:
		boss.attack1()
