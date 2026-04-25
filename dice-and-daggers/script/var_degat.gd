extends Label

var damage = 0

func _ready():
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _process(delta: float) -> void:
	text = "Dégâts global :\n" + str(damage)
