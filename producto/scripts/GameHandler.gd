extends Node

export var contadorDiscos = 1

func _ready():
	pass

func save_game():
	var save_game = File.new()
	save_game.open("user://producto/assets/other/Save/savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://producto/assets/other/Save/savegame.save"):
		return # Error! We don't have a save to load.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	save_game.open("user://producto/assets/other/Save/savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		for i in node_data.keys():
			if i == "filename" or i == "parent":
				continue
			new_object.set(i, node_data[i])
	save_game.close()

func _on_Area2D_Game_Over_body_entered(body):
	PantallaFade.change_scene("res://producto/scenes/NivelPlataforma.tscn")

func _on_Palanca_body_entered(body):
	if $Robot.contadorDiscos == 2:
		$"Sombra Secretos".visible = false

func addDisco():
	contadorDiscos+=1
	
func getDisco():
	return contadorDiscos

func _on_Trampolines_body_shape_entered(body_id, body, body_shape, local_shape):
	pass # Replace with function body.
