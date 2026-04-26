extends Camera2D

@onready var hp_boss = $HPBoss
@onready var shield_boss = $ShieldBoss
@onready var hp_joueur = $HPJoueur
@onready var shield_joueur = $ShieldJoueur

@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player == null or boss == null:
		return
	animer_barre(hp_joueur, player.hp)
	animer_barre(shield_joueur, player.shield)
	animer_barre(hp_boss, boss.getHp())
	
func animer_barre(barre: ProgressBar, valeur: float):
	valeur = clamp(valeur, barre.min_value, barre.max_value)
	var tween = create_tween()
	tween.tween_property(barre, "value", valeur, 0.3)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
