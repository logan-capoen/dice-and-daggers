extends Area2D

@export_group("Faces du Dé")
@export var face_1: Texture2D
@export var face_2: Texture2D
@export var face_3: Texture2D
@export var face_4: Texture2D
@export var face_5: Texture2D
@export var face_6: Texture2D

@onready var sprite = $Sprite2D
var pos_initiale_label : Vector2
var est_utilise = false
var valeur_finale = 0

func _ready():
	if has_node("ComboLabel"):
		pos_initiale_label = $ComboLabel.position
		$ComboLabel.hide()

func lancer_animation():
	if has_node("ComboLabel"): $ComboLabel.hide()
	for i in range(10):
		_appliquer_texture(randi_range(1, 6))
		await get_tree().create_timer(0.1).timeout
	
	valeur_finale = randi_range(1, 6)
	_appliquer_texture(valeur_finale)

func _appliquer_texture(num):
	match num:
		1: sprite.texture = face_1
		2: sprite.texture = face_2
		3: sprite.texture = face_3
		4: sprite.texture = face_4
		5: sprite.texture = face_5
		6: sprite.texture = face_6

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not est_utilise:
			appliquer_effet_face()

func appliquer_effet_face():
	est_utilise = true
	sprite.self_modulate = Color(0.3, 0.3, 0.3)
	
	var nom_img = sprite.texture.resource_path.get_file().get_basename()
	
	get_parent().gerer_clic_de(self, nom_img)
	
	match nom_img:
		"epee": print("Attaque !")
		"soin": print("Soin !")

func afficher_texte_combo(multiplicateur):
	if has_node("ComboLabel"):
		var label = $ComboLabel
		var tween = create_tween()
		
		label.position = pos_initiale_label
		label.modulate.a = 1.0
		label.text = "x" + str(multiplicateur)
		label.self_modulate = Color.GOLD if multiplicateur > 1.0 else Color.WHITE
		label.show()
		
		tween.tween_interval(0.5)
		tween.parallel().tween_property(label, "position:y", pos_initiale_label.y - 40, 1.0)
		tween.parallel().tween_property(label, "modulate:a", 0.0, 1.0)
		tween.tween_callback(label.hide)

func _mouse_enter():
	if not est_utilise: sprite.self_modulate = Color(2, 2, 0)
func _mouse_exit():
	if not est_utilise: sprite.self_modulate = Color(1, 1, 1)
