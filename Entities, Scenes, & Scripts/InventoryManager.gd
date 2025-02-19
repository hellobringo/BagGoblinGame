extends Node

@onready var inv : Inventory = $"../Inventory"
@onready var ctrl_inventory : CtrlInventoryGrid = $"../CtrlInventoryGrid"
@onready var sub_viewport : SubViewport = $"../../SubViewportContainer/InventoryWeapon"
# Load the CtrlDraggableInventoryItem script
@onready var ctrl_draggable_script = preload("res://addons/gloot/ui/ctrl_draggable_inventory_item.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	# Create and add the item to the inventory
	var item: InventoryItem = inv.create_and_add_item("2x4_sword")
	#item.set_property("image", sub_viewport.get_texture())
	await get_tree().process_frame
	print(item.get_properties())

func get_ctrl_inventory_item_for_inventory_item(_ctrl_inventory: CtrlInventoryGrid, item: InventoryItem) -> CtrlInventoryItem:
	# Access the internal _CtrlInventoryGridBasic instance
	var ctrl_inventory_basic = _ctrl_inventory.get("_ctrl_inventory_grid_basic")
	if !ctrl_inventory_basic:
#		print("return 1: _ctrl_inventory_grid_basic is invalid")
		return null
	
	# Ensure the grid is populated
	ctrl_inventory_basic._populate_list()
	
	# Wait for the grid to update
	await get_tree().process_frame
	
	# Access the _ctrl_item_container
	var ctrl_item_container = ctrl_inventory_basic.get("_ctrl_item_container")
	if !ctrl_item_container:
#		print("return 2: _ctrl_item_container is invalid")
		return null
	
	# Debug: Check the number of children in _ctrl_item_container
#	print("Number of children in _ctrl_item_container: ", ctrl_item_container.get_child_count())
	
	# Debug: Print the item being searched for
#	print("Item being searched for: ", item)
	
	# Iterate through the children of _ctrl_item_container to find the CtrlDraggableInventoryItem
	for child in ctrl_item_container.get_children():
		# Debug: Print the script and item of each child
#		print("Child script: ", child.get_script())
#		print("Child item: ", child.item)
		
		# Check if the child has the CtrlDraggableInventoryItem script
		if child.get_script() == ctrl_draggable_script && child.item == item:
			# Return the CtrlInventoryItem associated with the CtrlDraggableInventoryItem
#			print("return 3: Found matching CtrlDraggableInventoryItem")
			return child._ctrl_inventory_item
	
#	print("return 4: No matching CtrlDraggableInventoryItem found")
	return null
