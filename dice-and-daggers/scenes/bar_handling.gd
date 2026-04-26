extends Camera2D

@onready var hp_boss = $HPBoss
@onready var shield_boss = $ShieldBoss
@onready var hp_joueur = $HPJoueur
@onready var shield_joueur = $ShieldJoueur

@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player == null:
		print("player null !")
		return
	#print("HP joueur : ", player.hp, ", Shield : ", player.shield)
	animer_barre(hp_joueur, player.hp)
	animer_barre(shield_joueur, player.shield)
	if boss == null:
		print("boss null !")
		return
	#print("HP boss : ", boss.getHP())
	animer_barre(hp_boss, boss.getHP())
	
func animer_barre(barre: ProgressBar, valeur: float):
	valeur = clamp(valeur, barre.min_value, barre.max_value)
	var tween = create_tween()
	tween.tween_property(barre, "value", valeur, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
