class_name MapNode
extends TextureButton

@export var floor_index: int = 0
@export var difficulty_budget: int = 5
@export var node_type: String = "combat" # "combat", "rest", "boss"
@export var connected_nodes: Array[MapNode] = []

var is_active: bool = false

func _ready() -> void:
	# Avoid duplicate signals if re-entering screen
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)
	update_visuals()

func set_reachable(reachable: bool) -> void:
	is_active = reachable
	# DO NOT set disabled = true, or Godot hides buttons missing a Disabled Texture!
	update_visuals()

func update_visuals() -> void:
	# Active nodes = Full White (1.0), Locked nodes = Dim Gray (0.3)
	if is_active:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		modulate = Color(0.4, 0.4, 0.4, 0.4)

func _on_pressed() -> void:
	if not is_active:
		print("Clicked locked node: ", name)
		return
		
	print("Clicked ACTIVE node: ", name)
	gameManager.current_battle_budget = difficulty_budget
	
	# Save NodePath as a string so GameManager doesn't lose reference on scene reload
	gameManager.current_node_path = str(get_path())
	
	var map_manager = _find_map_manager(get_parent())
	if map_manager and map_manager.has_method("on_node_selected"):
		map_manager.on_node_selected(self)

func _find_map_manager(current_node: Node) -> Node:
	if current_node == null:
		return null
	if current_node.has_method("on_node_selected"):
		return current_node
	return _find_map_manager(current_node.get_parent())
