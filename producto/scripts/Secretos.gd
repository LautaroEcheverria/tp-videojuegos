extends Area2D

func _ready():
	pass # Replace with function body.

func _on_Zonas_Secretas_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.name == "Robot":
		match local_shape:
			0:
				get_parent().get_node("Sombra Secretos/Sombra Secretos 1").visible = false
			1:
				get_parent().get_node("Sombra Secretos/Sombra Secretos 2").visible = false
			2:
				get_parent().get_node("Sombra Secretos/Sombra Secretos 3").visible = false
				
func _on_Zonas_Secretas_body_shape_exited(body_id, body, body_shape, local_shape):
	if body.name == "Robot":
		match local_shape:
			0:
				get_parent().get_node("Sombra Secretos/Sombra Secretos 1").visible = true
			1:
				get_parent().get_node("Sombra Secretos/Sombra Secretos 2").visible = true
			2:
				get_parent().get_node("Sombra Secretos/Sombra Secretos 3").visible = true
