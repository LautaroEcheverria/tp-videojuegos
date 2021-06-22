extends Control

onready var coleccionables = [$Control/Contenido/Coleccionables/Col1,
$Control/Contenido/Coleccionables/Col2,
$Control/Contenido/Coleccionables/Col3,
$Control/Contenido/Coleccionables/Col4]

var disco1 = preload("res://producto/assets/img/UI/Inventario/inv_1.png")
var disco2 = preload("res://producto/assets/img/UI/Inventario/inv_2.png")
var disco3 = preload("res://producto/assets/img/UI/Inventario/inv_3.png")
var disco4 = preload("res://producto/assets/img/UI/Inventario/inv_4.png")

var array_discos = [disco1,disco2,disco3,disco4]

var discos = GameHandler.getDisco()
var diccionario_coleccionables
var nivelSelect = 0 # Nivel seleccionado para jugar devuelta (disco)
var discoSelect # Restriccion para habilitar boton jugar solo si selecciono disco

func _ready():
	$Control.hide()
	$opacidad.hide()
	diccionario_coleccionables = GameHandler.get_diccionario_coleccionables()
	habilitarItems()
	discoSelect = false # Por defecto en false

func habilitarItems():
	for i in range(GameHandler.getDisco()):
		print(i)
		$Control/Contenido/Items/PanelContainer/ItemList.set_item_disabled(i,false)
		$Control/Contenido/Items/PanelContainer/ItemList.set_item_icon(i,array_discos[i])
	if GameHandler.contadorDiscos >= 1:
		var idColeccionables = GameHandler.player_data.coleccionables
		for i in range(len(idColeccionables)):
			if idColeccionables[i] == true:
				print(diccionario_coleccionables[i])
				agregarColeccionable(i,diccionario_coleccionables[i][0],diccionario_coleccionables[i][1])

func agregarColeccionable(i,nombre,texto):
	$Control/Contenido/Items/PanelContainer/ItemList.set_item_disabled(i+4,false)
	coleccionables[i].get_node("NombreItem").set_text(nombre)
	coleccionables[i].get_node("TextoItem").set_text(texto)
	
func _on_InventoryButton_pressed():
	if(!visible):
		visible = !visible
		$Control/AnimationPlayer.play("open")
		$Control.visible = !$Control.visible
		$opacidad.visible = !$opacidad.visible
	else:
		$Control/AnimationPlayer.play("close")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "close":
		visible = !visible
		$Control.visible = !$Control.visible
		$opacidad.visible = !$opacidad.visible
	
func _on_volver_pressed():
	$Control/Contenido/Coleccionables.visible = false
	$Control/Contenido/Items.visible = true
	for i in range(len(coleccionables)):
		coleccionables[i].visible = false

func mostrarInfo(i):
	var nivel = i+1
	var score = GameHandler.get_score_nivel_ritmico(nivel)
	var info = $Control/Contenido/Items/InfoDisco
	if nivel == 1:
		info.get_node("NombreItem").set_text("Oblivion")
	elif nivel == 2:
		info.get_node("NombreItem").set_text("Violentango")
	elif nivel == 3:
		info.get_node("NombreItem").set_text("Libertango")
	elif nivel == 4:
		info.get_node("NombreItem").set_text("Adios Nonino")
	info.get_node("TextoItem").set_text("puntos: " + str(score))

func _on_ItemList_item_selected(index):
	if !$Control/Contenido/Items/PanelContainer/ItemList.is_item_disabled(index):
		if index <4:
			$Control/Contenido/Items/InfoDisco.visible = true
			mostrarInfo(index)
			nivelSelect = index+1
			discoSelect = true
		else:
			$Control/Contenido/Items.visible = false
			$Control/Contenido/Coleccionables.visible = true
			coleccionables[index-4].visible = true

func _on_Jugar_pressed():
	if discoSelect:
		GameHandler.replayNivelRitmico = true
		GameHandler.set_nivel_ritmico(nivelSelect)
		PantallaFade.change_scene("res://producto/scenes/Ritmo/NivelRitmicoInicio.tscn")
