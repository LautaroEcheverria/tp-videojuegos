extends Area2D

func _ready():
	pass

func _down(id):
	match id:
		0:
			$Trampolin1._down()
		1:
			$Trampolin2._down()
		2:
			$Trampolin3._down()
		3:
			$Trampolin4._down()
		4:
			$Trampolin5._down()

func _up(id):
	match id:
			0:
				$Trampolin1._up()
			1:
				$Trampolin2._up()
			2:
				$Trampolin3._up()
			3:
				$Trampolin4._up()
			4:
				$Trampolin5._up()

