extends Area2D

@export_group("Faces du Dé")
@export var face_1: Texture2D
@export var face_2: Texture2D
@export var face_3: Texture2D
@export var face_4: Texture2D
@export var face_5: Texture2D
@export var face_6: Texture2D

@onready var sprite = $Sprite2D
var est_utilise = false
var valeur_finale = 0 # On stockera le résultat ici

func lancer_animation():
	# PHASE DE ROULEMENT
	for i in range(10):
		var faux_res = randi_range(1, 6)
		_appliquer_texture(faux_res)
		await get_tree().create_timer(0.1).timeout

	# RÉSULTAT FINAL
	valeur_finale = randi_range(1, 6)
	_appliquer_texture(valeur_finale)

# Petite fonction interne pour éviter de répéter le match
func _appliquer_texture(num):
	match num:
		1: sprite.texture = face_1
		2: sprite.texture = face_2
		3: sprite.texture = face_3
		4: sprite.texture = face_4
		5: sprite.texture = face_5
		6: sprite.texture = face_6

func _mouse_enter():
	# Si le dé est déjà utilisé, on ne fait RIEN (il reste gris)
	if est_utilise: 
		return
	sprite.self_modulate = Color(2, 2, 0) # Jaune brillant

func _mouse_exit():
	if est_utilise: 
		return
	sprite.self_modulate = Color(1, 1, 1) # Retour au blanc

# 2. GESTION DU CLIC
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not est_utilise:
			valider_utilisation()

func valider_utilisation():
	est_utilise = true
	# On le grise DEFINITIVEMENT pour ce tour
	sprite.self_modulate = Color(0.3, 0.3, 0.3) 
	print("Dé bloqué avec la valeur : ", valeur_finale)
