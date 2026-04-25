extends Node2D

func _on_button_pressed():
	# 1. On récupère tous les dés du groupe
	var tous_les_des = get_tree().get_nodes_in_group("dés")
	
	# 2. VÉRIFICATION : Est-ce qu'ils sont tous utilisés ?
	for de in tous_les_des:
		if de.est_utilise == false:
			print("Action impossible : tu dois utiliser tous les dés !")
			# Optionnel : faire trembler le bouton ou changer sa couleur ici
			return # IMPORTANT : On sort de la fonction, le reste du code n'est pas lu
	
	# 3. RÉINITIALISATION ET RELANCE
	# Si on arrive ici, c'est que la boucle du dessus n'a pas trouvé de dé "non utilisé"
	print("Bravo ! Tous les dés étaient utilisés. Relance en cours...")
	
	for de in tous_les_des:
		de.est_utilise = false            # On déverrouille le dé
		de.sprite.self_modulate = Color(1, 1, 1) # On lui redonne sa couleur normale (blanc)
		de.lancer_animation()             # On lance le nouveau roulement
	
	# On attend la fin de l'anim avant de redonner la main
	await get_tree().create_timer(1.1).timeout
