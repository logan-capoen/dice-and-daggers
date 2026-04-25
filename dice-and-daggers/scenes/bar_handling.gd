extends Camera2D

@onready var hp_boss = $HPBoss
@onready var shield_boss = $ShieldBoss
@onready var hp_joueur = $HPJoueur
@onready var shield_joueur = $ShieldJoueur

func _input(event):
	if event.is_action_pressed("z"):
		animer_barre(hp_joueur, hp_joueur.value + 10)
	if event.is_action_pressed("s"):
		animer_barre(hp_joueur, hp_joueur.value - 10)
	if event.is_action_pressed("e"):
		animer_barre(shield_joueur, shield_joueur.value + 10)
	if event.is_action_pressed("d"):
		animer_barre(shield_joueur, shield_joueur.value - 10)
	if event.is_action_pressed("r"):
		animer_barre(hp_boss, hp_boss.value + 10)
	if event.is_action_pressed("f"):
		animer_barre(hp_boss, hp_boss.value - 10)
	if event.is_action_pressed("t"):
		animer_barre(shield_boss, shield_boss.value + 10)
	if event.is_action_pressed("g"):
		animer_barre(shield_boss, shield_boss.value - 10)

func animer_barre(barre: ProgressBar, valeur: float):
	valeur = clamp(valeur, barre.min_value, barre.max_value)
	var tween = create_tween()
	tween.tween_property(barre, "value", valeur, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
