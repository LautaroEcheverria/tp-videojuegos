extends Area2D

export var nroDisco = 0

var disco1 = preload("res://producto/assets/img/Plataformas/Discos/d_azul.png")
var disco2 = preload("res://producto/assets/img/Plataformas/Discos/d_rojo.png")
var disco3 = preload("res://producto/assets/img/Plataformas/Discos/d_verde.png")
var disco4 = preload("res://producto/assets/img/Plataformas/Discos/d_final.png")

var discos = [disco1,disco2,disco3,disco4]

onready var disco_sprite = get_node("Sprite")

func _ready():
	disco_sprite.set_texture(discos[nroDisco])
	#falta texto cartel
	
func _physics_process(delta):
	$AnimationDisco.play("disco")	
	if GameHandler.getDisco() > nroDisco:
		get_parent().remove_child(self)

func _on_Area2D_body_entered(body):
	if body.name == "Robot":
		if $AnimationCartel.current_animation != "Hover":
			$AnimationCartel.play("Hover")	
	
func _on_Area2D_body_exited(body):
	if body.name == "Robot":
		$AnimationCartel.rename_animation("Hover","Hover_inv")
		$AnimationCartel.play("Hover_inv",1,-2,true)	

func _on_AnimationCartel_animation_finished(anim_name):
	if anim_name == "Hover":
		$AnimationCartel.play("Activo")	
	elif anim_name == "Hover_inv":
		$AnimationCartel.rename_animation("Hover_inv","Hover")
		$AnimationCartel.play("Inactivo")	

func _on_TouchScreenButton_pressed():
	GameHandler.addDisco()
	get_parent().get_node("Robot").cambiarEstado()
	PantallaFade.change_scene("res://producto/scenes/Ritmo/NivelRitmicoInicio.tscn")
