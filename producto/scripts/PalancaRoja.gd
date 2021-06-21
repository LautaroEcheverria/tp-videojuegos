extends Area2D

var activo = [false]

func _ready():
	activo = GameHandler.get_palancas()

func _on_Rojo_body_shape_entered(body_id, body, body_shape, local_shape):
	activo[local_shape] = !activo[local_shape]
	GameHandler.actualizaPalancas(local_shape,activo[local_shape])
	self._actualizaEstados()

func _actualizaEstados():
	var estadoPlataforma: bool
	var contadorDiscos = GameHandler.getDisco()
	if contadorDiscos >= 2:
		estadoPlataforma = get_parent().get_node("Rojo/Ascensor")._get("activo")
		if  activo[0]:
			get_parent().get_node("Sombra Secretos/Sombra de descubrimiento Interior").visible = false
			if estadoPlataforma == false:
				get_parent().get_node("Rojo/Ascensor")._set("activo",true)
		else:
			get_parent().get_node("Sombra Secretos/Sombra de descubrimiento Interior").visible = true
			if estadoPlataforma:
				get_parent().get_node("Rojo/Ascensor")._set("activo",false)
