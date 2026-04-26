extends Label

var damage = 0
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _process(delta: float) -> void:
	text = "Dégâts global :\n" + str(damage)
