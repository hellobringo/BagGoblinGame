extends CtrlInventoryItem

@onready var sub_viewport: SubViewport = $InventoryWeapon


func _update_texture() -> void:
	_texture_rect = $TextureRect
	_texture_rect.texture = sub_viewport.get_texture()
	_texture_rect.size = Vector2(size.y, size.x)
	$Label.text = "UPDATED"
	if !is_instance_valid(_texture_rect):
		return

	if is_instance_valid(item):
		if item.has_property("image") : _texture_rect.texture = item.get_texture()
	else:
#		_texture_rect.texture = null
		return

	if is_instance_valid(item) && GridConstraint.is_item_rotated(item):
		print("1")
		_texture_rect.size = Vector2(size.y, size.x)
		if GridConstraint.is_item_rotation_positive(item):
			print("2")
			_texture_rect.position = Vector2(_texture_rect.size.y, 0)
			_texture_rect.rotation = PI / 2
		else:
			print("3")
			_texture_rect.position = Vector2(0, _texture_rect.size.x)
			_texture_rect.rotation = -PI / 2

	else:
		print("4")
		_texture_rect.size = size
		_texture_rect.position = Vector2.ZERO
		_texture_rect.rotation = 0
