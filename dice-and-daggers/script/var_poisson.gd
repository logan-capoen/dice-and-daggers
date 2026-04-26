extends Label

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _process(delta: float) -> void:
	if player == null:
		return
	text = "Dégâts poison :\n" + str(player.damage_poison)
