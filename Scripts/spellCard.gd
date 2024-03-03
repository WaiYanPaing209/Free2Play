extends TextureButton

func _ready():
	$button.connect("mouse_entered",self,"entered")
	$button.connect("pressed",self,"Onpressed")
	
func entered():
	print("mouse entered")
	
func Onpressed():
	print("is pressed!")
