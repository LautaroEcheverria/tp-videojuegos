extends Area2D

onready var animationPlayer = $AnimationPlayer

export var nroDisco = 1

func _physics_process(delta):
	var bodies = get_overlapping_bodies() # info de los cuerpos que colisionan con el disco
	animationPlayer.play("Idle") #reproduce animación
	
	for body in bodies:
		if body.name == "Robot":
			body.contadorDiscos +=1
			get_parent().remove_child(self) # elimina disco de la escena
			print(body.contadorDiscos)
