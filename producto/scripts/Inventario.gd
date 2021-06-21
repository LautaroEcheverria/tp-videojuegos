extends Control

onready var coleccionables = [$Control/Coleccionables/Col1,
$Control/Coleccionables/Col2,
$Control/Coleccionables/Col3,
$Control/Coleccionables/Col4]

var discos = GameHandler.getDisco()
var diccionario_coleccionables

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.hide()
	$opacidad.hide()
	diccionario_coleccionables = GameHandler.get_diccionario_coleccionables()
	habilitarItems()

func habilitarItems():
	for i in range(GameHandler.getDisco()):
		print(i)
		$Control/Items/PanelContainer/ItemList.set_item_disabled(i,false)
	var idColeccionables = GameHandler.player_data.coleccionables
	for i in range(len(idColeccionables)):
		if idColeccionables[i] == true:
			print(diccionario_coleccionables[i])
			agregarColeccionable(i,diccionario_coleccionables[i][0],diccionario_coleccionables[i][1])

		
func agregarColeccionable(i,nombre,texto):
	$Control/Items/PanelContainer/ItemList.set_item_disabled(i+4,false)
	coleccionables[i].get_node("NombreItem").set_text(nombre)
	coleccionables[i].get_node("TextoItem").set_text(texto)
	

func _on_InventoryButton_pressed():
	visible = !visible
	$Control.visible = !$Control.visible
	$opacidad.visible = !$opacidad.visible
	print("abrir inventario")

func _on_volver_pressed():
	$Control/Coleccionables.visible = false
	$Control/Items.visible = true
	for i in range(len(coleccionables)):
		coleccionables[i].visible = false


func mostrarInfo(i):
	var nivel = i+1
	var score = GameHandler.get_score_nivel_ritmico(nivel)
	var info = $Control/Items/InfoDisco
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
	if !$Control/Items/PanelContainer/ItemList.is_item_disabled(index):
		if index <4:
			$Control/Items/InfoDisco.visible = true
			mostrarInfo(index)
		else:
			$Control/Items.visible = false
			$Control/Coleccionables.visible = true
			coleccionables[index-4].visible = true
