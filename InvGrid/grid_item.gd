extends Node2D
var myImage = 0
var isPlaced = false
var canbePlaced = false
var xsize = 0
var ysize = 0
var isMouseHover = false
var isInBoundary = false
var canbeEquipped = false
var justAdded = false
@onready var oldTex = $mySprite.texture
var myImagenum = "0"

func _ready() -> void:
	var myImageload = load("res://InvGrid/"+str(myImage)+".png")
	$mySprite.set_texture(myImageload)
	xsize = $mySprite.texture.get_width()/32
	ysize = $mySprite.texture.get_height()/32

func _process(delta: float) -> void:
	checkPlacement()
	var myTextbox = get_parent().get_parent().get_child(1)

	var XN = get_viewport().get_mouse_position()
	var approxX = round((XN.x-16)/32)*32
	var approxY = round((XN.y-16)/32)*32
	isMouseHover = false 
	if (XN.x > self.global_position.x && XN.x < self.global_position.x+xsize*32):
		if (XN.y > self.global_position.y && XN.y < self.global_position.y+ysize*32):
			isMouseHover = true
			print("YEP YEP")
	myTextbox.global_position.x = XN.x+16
	myTextbox.global_position.y = XN.y+16
	var myTex = $mySprite.texture
	if (myTex != oldTex):
		var myImageload = load("res://InvGrid/"+str(myImage)+".png")
		$mySprite.set_texture(myImageload)
		xsize = $mySprite.texture.get_width()/32
		ysize = $mySprite.texture.get_height()/32
		if (justAdded):
			autoadd()
			justAdded = false
	if (!isPlaced):
		print(global_position)
		if isInBoundary:
			self.global_position.x = approxX
			self.global_position.y = approxY
		else:
			self.global_position.x = XN.x-16
			self.global_position.y = XN.y-16
		if Input.is_action_just_pressed('place'):
			if canbePlaced:
				isPlaced = true;
			if (!isInBoundary):
				self.queue_free()
	else:
		if (isMouseHover):
			if Input.is_action_just_pressed('place'):
				if canbePlaced:
					get_parent().move_child(self, get_parent().get_child_count())
					isPlaced = false
	if (!canbePlaced):
		$mySprite.self_modulate.a = 0.5
	else:
		$mySprite.self_modulate.a = 1
	oldTex = $mySprite.texture


func checkPlacement():
	canbePlaced = true;
	var XN = get_viewport().get_mouse_position()
	for m in get_parent().get_child_count():
		var myCompare = get_parent().get_child(m)
		if (myCompare != self):
			if (self.position.x+xsize*32 > myCompare.position.x && self.position.x < myCompare.position.x+myCompare.xsize*32 && self.position.y+ysize*32 > myCompare.position.y && self.position.y < myCompare.position.y+myCompare.ysize*32):
				canbePlaced = false;
							
	isInBoundary = false
	if (XN.x > get_parent().get_parent().myLeft && XN.x < get_parent().get_parent().myRight && XN.y > get_parent().get_parent().myTop && XN.y < get_parent().get_parent().myBottom):
		if (XN.x+xsize*32 < get_parent().get_parent().myRight+32 && XN.y+ysize*32 < get_parent().get_parent().myBottom+32):
			isInBoundary = true
	if (canbePlaced && isInBoundary):
		return true

func autoadd():
	for m in get_parent().get_parent().gridheight:
		for n in get_parent().get_parent().gridwidth:	
			self.global_position.x = get_parent().get_parent().myLeft+n*32
			self.global_position.y = get_parent().get_parent().myTop+m*32
			if (self.global_position.x > get_parent().get_parent().myLeft-32 && self.global_position.x+xsize*32 < get_parent().get_parent().myRight+32 && self.global_position.y > get_parent().get_parent().myTop-32 && self.global_position.y+ysize*32 < get_parent().get_parent().myBottom+32):
				checkPlacement()
				print(checkPlacement())
				if (canbePlaced):
					isPlaced = true;
					return;
	self.queue_free()
	return
