extends Node2D

@onready var party_token: Node2D = $PartyToken
@onready var lines_container: Node2D = $LinesContainer

func _ready() -> void:
	_draw_connection_lines()
	
	# ONLY process state once via current_node_path on scene load
	if gameManager.current_node_path != "":
		_on_map_node_completed(gameManager.current_node_path)
	else:
		_setup_starting_nodes()

func _on_map_node_completed(completed_path: String) -> void:
	print("\n--- [MAP DEBUG START] ---")
	print("Requested completed_path: ", completed_path)
	
	_disable_all_nodes()
	
	var completed_node: MapNode = null
	var all_nodes = _get_all_map_nodes()
	
	# 1. First try direct NodePath lookup
	if HasNode(completed_path):
		completed_node = get_node_or_null(completed_path) as MapNode
		
	# 2. String Path Match Fallback: compare exact NodePath string representations
	if completed_node == null:
		for n in all_nodes:
			if str(n.get_path()) == completed_path:
				completed_node = n
				break
				
	# 3. Name Match Fallback
	if completed_node == null:
		var target_name = completed_path.get_file()
		for n in all_nodes:
			if n.name == target_name:
				completed_node = n
				break

	if completed_node:
		print("FOUND NODE: ", completed_node.name, " | Floor: ", completed_node.floor_index)
		party_token.global_position = _get_node_center(completed_node)
		
		var target_floor = completed_node.floor_index + 1
		var unlocked_count := 0
		
		for next_node in completed_node.connected_nodes:
			if is_instance_valid(next_node) and next_node.floor_index == target_floor:
				next_node.set_reachable(true)
				unlocked_count += 1
				print("  --> UNLOCKED: ", next_node.name)
		
		if unlocked_count == 0:
			print("  --> FALLBACK TRIGGERED: Enabling all nodes on Floor ", target_floor)
			_enable_floor(target_floor)
	else:
		print("❌ CRITICAL: Could not find node for path '", completed_path, "'. Resetting to start.")
		_setup_starting_nodes()
		
	print("--- [MAP DEBUG END] ---\n")

func HasNode(path_str: String) -> bool:
	return get_tree().root.has_node(path_str)
	

func on_node_selected(node: MapNode) -> void:
	gameManager.current_map_node = node
	
	var target_pos = _get_node_center(node)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(party_token, "global_position", target_pos, 0.4)
	
	await tween.finished
	
	match node.node_type:
		"combat", "boss":
			get_tree().change_scene_to_file("res://battlefield_test.tscn")
		"rest":
			get_tree().change_scene_to_file("res://RestSite.tscn")

# Recursively finds all MapNodes anywhere in the DungeonMap scene
func _get_all_map_nodes(parent: Node = self) -> Array[MapNode]:
	var map_nodes: Array[MapNode] = []
	for child in parent.get_children():
		if child is MapNode:
			map_nodes.append(child)
		if child.get_child_count() > 0:
			map_nodes.append_array(_get_all_map_nodes(child))
	return map_nodes

func _disable_all_nodes() -> void:
	for node in _get_all_map_nodes():
		node.set_reachable(false)

func _enable_floor(target_floor: int) -> void:
	for node in _get_all_map_nodes():
		if node.floor_index == target_floor:
			node.set_reachable(true)

func _setup_starting_nodes() -> void:
	_disable_all_nodes()
	var all_nodes = _get_all_map_nodes()
	var first_active_set := false
	
	for node in all_nodes:
		if node.floor_index == 0:
			node.set_reachable(true)
			if not first_active_set:
				party_token.global_position = _get_node_center(node)
				first_active_set = true

func _draw_connection_lines() -> void:
	for line in lines_container.get_children():
		line.queue_free()
		
	var all_nodes = _get_all_map_nodes()
	print("Drawing lines for ", all_nodes.size(), " nodes...")
	
	for node in all_nodes:
		var start_center = _get_node_center(node)
		for target in node.connected_nodes:
			if is_instance_valid(target):
				var end_center = _get_node_center(target)
				
				var line = Line2D.new()
				line.add_point(start_center)
				line.add_point(end_center)
				
				line.width = 6.0
				line.default_color = Color(1.0, 1.0, 1.0, 0.8)
				line.z_index = 1
				
				lines_container.add_child(line)

func _get_node_center(node: MapNode) -> Vector2:
	var node_size = node.size
	if node_size == Vector2.ZERO:
		node_size = node.get_combined_minimum_size()
	return node.global_position + (node_size / 2.0)
