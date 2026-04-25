extends Node2D

func _on_button_pressed():
	print("Lancement simultané de tous les dés !")
	
	# 1. On récupère dynamiquement tous les membres du groupe "dés"
	var tous_les_des = get_tree().get_nodes_in_group("dés")
	
	if tous_les_des.is_empty():
		print("Erreur : Aucun dé trouvé dans le groupe 'dés'")
		return

	$Button.disabled = true
	
	# 2. On lance l'animation sur chaque dé trouvé
	for de in tous_les_des:
		de.lancer_animation()
	
	# 3. On attend la fin du roulement
	await get_tree().create_timer(1.1).timeout
	
	# 4. On calcule le total dynamiquement
	var total = 0
	for de in tous_les_des:
		total += de.valeur_finale
	
	print("Le résultat total est : ", total)
	$Button.disabled = false
