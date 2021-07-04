extends Area2D

func _ready():
	pass # Replace with function body.

func _on_Zonas_Secretas_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.name == "Robot":
		match local_shape:
			0:
				get_parent().get_node("Azul/Sombra Secretos/Sombra Secretos 1/AnimacionSombra").play("fade out")
			1:
				get_parent().get_node("Azul/Sombra Secretos/Sombra Secretos 2/AnimacionSombra").play("fade out")
			2:
				get_parent().get_node("Azul/Sombra Secretos/Sombra Secretos 3/AnimacionSombra").play("fade out")
				
func _on_Zonas_Secretas_body_shape_exited(body_id, body, body_shape, local_shape):
	if body.name == "Robot":
		match local_shape:
			0:
				get_parent().get_node("Azul/Sombra Secretos/Sombra Secretos 1/AnimacionSombra").play("fade in")
			1:
				get_parent().get_node("Azul/Sombra Secretos/Sombra Secretos 2/AnimacionSombra").play("fade in")
			2:
				get_parent().get_node("Azul/Sombra Secretos/Sombra Secretos 3/AnimacionSombra").play("fade in")
