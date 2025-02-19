extends Node2D
var gridwidth = 18
var gridheight = 8
var gridicon = preload("res://InvGrid/gridsquare.png");
var myLeft = 0
var myRight = 0
var myTop = 0
var myBottom = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position.x = round((get_viewport().size.x/2-gridwidth*32/2)/32)*32
	self.position.y = round((get_viewport().size.y-(gridheight*32+32))/32)*32
	myLeft = self.position.x
	myTop = self.position.y
	myRight = self.position.x+gridwidth*32
	myBottom = self.position.y+gridheight*32
	$myItemLabel.visible = false
	for n in $allItems.get_child_count():
		if ($allItems.get_child(n).isMouseHover): print("hovering : ", $allItems.get_child(n).name)
		if ($allItems.get_child(n).isMouseHover || $allItems.get_child(n).isPlaced == false):
			$myItemLabel.visible = true
			$myItemLabel.text = "ITEM "+str($allItems.get_child(n).myImage)
			if $allItems.get_child(n).canbePlaced == false:
				$myItemLabel.text = "YOU CANT PLACE HERE FUCKWIT"
				$myItemLabel.visible = true
		if $allItems.get_child(n).isInBoundary == false:
			$myItemLabel.text = "DISCARD ITEM"
	#self.position.x = get_viewport().size.x/2-gridwidth*32/2
	#self.position.y = get_viewport().size.y-(gridheight*32+32)
	
func _draw():
	for n in gridwidth:
		for m in gridheight:
			draw_texture_rect(gridicon, Rect2(32*n,32*m,32,32), false)
