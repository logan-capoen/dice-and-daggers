extends Node2D
class_name BossBase

# --- STATISTIQUES MODULABLES ---
@export_group("Stats du Boss")
@export var boss_name: String = "Boss Inconnu"
@export var max_hp: int = 100
@export var defense: int = 5
@export var attack1_damage: int = 15
@export var attack2_damage: int = 25

@export_group("Comportement")
@export var has_intro: bool = false #cocher si y a une intro

# --- VARIABLES INTERNES ---
var current_hp: int
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

# --- SIGNAUX (Optionnel mais recommandé pour avertir le jeu) ---
signal on_boss_died
signal on_boss_attacked(damage_amount)

func _ready() -> void:
    current_hp = max_hp
    
    # On connecte le signal de fin d'animation de l'AnimatedSprite2D
    anim_sprite.animation_finished.connect(_on_animation_finished)
    
    if has_intro:
        anim_sprite.play("intro")
    else:
        anim_sprite.play("idle")

func getHP() -> int:
	return current_hp

func hurt(damage: int) -> void:
	if current_hp <= 0:
		return
		
	var actual_damage = max(damage - defense, 0)
	current_hp -= actual_damage
	
	print(boss_name + " a pris " + str(actual_damage) + " dégâts. HP restants : " + str(current_hp))
	if current_hp <= 0:
        die()
    else:
        anim_sprite.play("hurt") # On utilise anim_sprite au lieu de anim_player

# Attaque 1
func attack1() -> void:
	if current_hp > 0:
		anim_player.play("attack1")
		# Tu pourras appeler la fonction de dégâts sur le joueur ici
		# Exemple via signal : on_boss_attacked.emit(attack1_damage)
		print(boss_name + " lance l'Attaque 1 !")

# Attaque 2
func attack2() -> void:
	if current_hp > 0:
		anim_player.play("attack2")
		print(boss_name + " lance l'Attaque 2 !")

# Mourir
func die() -> void:
	current_hp = 0
	anim_player.play("die")
	print(boss_name + " est vaincu !")
	on_boss_died.emit()
	loot()

# Lâcher du butin
func loot() -> void:
	print(boss_name + " lâche son butin !")
	# Implémente ici ta logique de loot (instancier un objet, ajouter à l'inventaire du joueur, etc.)

# --- GESTION DES ÉTATS D'ANIMATION ---

func _on_animation_finished() -> void:
    # Le signal de l'AnimatedSprite2D n'envoie pas le nom de l'animation en paramètre.
    # On vérifie donc le nom de l'animation actuellement en train de jouer :
    var anim_name = anim_sprite.animation
    
    if anim_name in ["intro", "hurt", "attack1", "attack2"]:
        if current_hp > 0:
            anim_sprite.play("idle")
	elif anim_name == "die":
		pass # Tu peux utiliser queue_free() ici si tu veux faire disparaître le corps
