extends Node2D

export var id: int
export var nombre: String
export var texto: String
export var flip: bool

enum State{
	IdleClose,
	IdleOpen,
	Open,
	Close
}

var state = State.IdleClose
# Called when the node enters the scene tree for the first time.
func _ready():
	$cartel/nombre.text = nombre
	if flip:
		$ColeccionableArea/Coleccionable.flip_h = true
	else:
		$ColeccionableArea/Coleccionable.flip_h = false
	pass

func _physics_process(delta):
	if (state == State.IdleOpen):
		if $ColeccionableArea/Coleccionable.animation != "Idle_Open":
			$ColeccionableArea/Coleccionable.play("Idle_Open")
	elif (state == State.IdleClose):
		if $ColeccionableArea/Coleccionable.animation != "Idle_Close":
			$ColeccionableArea/Coleccionable.play("Idle_Close")
	elif (state == State.Open):
		if $ColeccionableArea/Coleccionable.animation != "Open":
			$ColeccionableArea/Coleccionable.play("Open")
		if $ColeccionableArea/Coleccionable.frame == 03:
			state = State.IdleOpen
	elif (state == State.Close):
		if $ColeccionableArea/Coleccionable.animation != "Close":
			$ColeccionableArea/Coleccionable.play("Close")
		if $ColeccionableArea/Coleccionable.frame == 03:
			state = State.IdleClose
func _open():
	state = State.Open

func _close():
	state = State.Close


func _on_ColeccionableArea_body_entered(body):
	_open()
	if $AnimationCartel.current_animation != "Hover":
		$AnimationCartel.play("Hover")	
	$cartel/nombre.visible = true
	$cartel/recoger.visible = true

func _on_ColeccionableArea_body_exited(body):
	_close()
	$AnimationCartel.rename_animation("Hover","Hover_inv")
	$AnimationCartel.play("Hover_inv",1,-2,true)	
	$cartel/nombre.visible = false
	$cartel/recoger.visible = false

func _on_AnimationCartel_animation_finished(anim_name):
	if anim_name == "Hover":
		$AnimationCartel.play("Activo")	
	elif anim_name == "Hover_inv":
		$AnimationCartel.rename_animation("Hover_inv","Hover")
		$AnimationCartel.play("Inactivo")	


func _on_ConseguirColeccionable_pressed():
	GameHandler.addColeccionable(id,nombre,texto)
