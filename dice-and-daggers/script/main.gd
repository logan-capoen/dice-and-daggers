extends Node2D

var dernier_nom : String = ""
var combo_actuel : int = 0
var multiplicateurs = [1.0, 1.5, 2.0, 4.0, 8.0, 16.0, 32.0]

func gerer_clic_de(de_clique: Area2D, nom_image: String):
	# LOGIQUE DU COMBO
	if nom_image == dernier_nom:
		combo_actuel += 1
	else:
		combo_actuel = 0
	
	combo_actuel = min(combo_actuel, multiplicateurs.size() - 1)
	dernier_nom = nom_image # On retient le nom pour le prochain clic
	
	var m = multiplicateurs[combo_actuel]
	
	# On demande au dé d'afficher le multiplicateur calculé
	de_clique.afficher_texte_combo(m)
	
	# On applique l'effet global (dégâts, etc.)
	appliquer_effet_global(nom_image, m)

@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var player = get_tree().get_first_node_in_group("player")

func appliquer_effet_global(nom, multi):
	match nom:
		"epee":
			var degats = 10 * multi
			boss.hurt(degats)
		"soin":
			var soin = 5 * multi
			player.hp = min(player.hp + soin, 100)

func _on_button_pressed():
	# RESET DU TOUR
	dernier_nom = ""
	combo_actuel = 0
	
	var tous_les_des = get_tree().get_nodes_in_group("dés")
	
	# Vérification si tous utilisés
	for de in tous_les_des:
		if not de.est_utilise:
			print("Utilise tous les dés d'abord !")
			return

	# Relance
	for de in tous_les_des:
		de.est_utilise = false
		de.sprite.self_modulate = Color(1, 1, 1)
		de.lancer_animation()
		
func _ready():
	if boss == null:
		return
	boss.on_boss_attacked.connect(_on_boss_attacked)
	boss.on_boss_died.connect(_on_boss_died)

func _on_boss_attacked(degats):
	player.take_damage(degats)

func _on_boss_died():
	print("Boss mort")
