extends AnimatedSprite

func _ready():
	pass # Replace with function body.

func save():
	var save_dict = {
		"filename" : get_owner().get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"frame" : get_frame(),
		"sprite_frames" : get_sprite_frames()
	}
	return save_dict
