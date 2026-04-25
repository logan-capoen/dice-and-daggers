extends Label

var poison_damage = 0

func _ready():
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _process(delta: float) -> void:
	text = "Dégâts poisson :\n" + str(poison_damage)
