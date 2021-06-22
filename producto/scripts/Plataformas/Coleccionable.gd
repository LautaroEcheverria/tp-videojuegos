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

var habilitado = true

func _ready():
	var array_coleccionables = GameHandler.get_coleccionables()
	if array_coleccionables[id]:
		deshabilitar()
	$cartel/nombre.text = nombre
	if flip:
		$ColeccionableArea/Coleccionable.flip_h = true
	else:
		$ColeccionableArea/Coleccionable.flip_h = false

func deshabilitar():
	habilitado = false
	$AnimationCartel.rename_animation("Hover","Hover_inv")
	$AnimationCartel.play("Hover_inv",1,-2,true)	
	state = State.IdleOpen

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
	if (body.name == "Robot" and habilitado):
		_open()
		if $AnimationCartel.current_animation != "Hover":
			$AnimationCartel.play("Hover")	
		$cartel/nombre.visible = true
		$cartel/recoger.visible = true

func _on_ColeccionableArea_body_exited(body):
	if (body.name == "Robot" and habilitado):
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
	GameHandler.addColeccionable(id)
	deshabilitar()
	get_parent().get_node("Canvas_inventario/Inventario").agregarColeccionable(id,nombre,texto)
