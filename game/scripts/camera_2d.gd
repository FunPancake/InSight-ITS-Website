extends Camera2D

var fixed_y : float

func _ready():
	fixed_y = global_position.y

func _process(_delta):
	global_position.y = fixed_y
