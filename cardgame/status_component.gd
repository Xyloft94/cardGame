extends Node2D

signal processing_finished

var active_statuses : Dictionary = {} # Remove any default values here

func _ready():
	# This line is the "Reset" button for each individual instance
	active_statuses = {}

func add_effect(effect_name: String, data: Dictionary):
	if active_statuses.has(effect_name):
		# STACKING: Add the new damage to the existing damage
		active_statuses[effect_name]["damage"] += data["damage"]
		# REFRESH: Reset the duration to the new amount
		active_statuses[effect_name]["turns"] = data["turns"]
		print(effect_name, " stacked! New total: ", active_statuses[effect_name]["damage"])
	else:
		# NEW: Use a duplicate of the dictionary so we don't mess up the Card's data
		active_statuses[effect_name] = data.duplicate()

func get_status_description() -> String:
	if active_statuses.is_empty():
		return ""
	
	var text = "" # Removed the "[STATUS EFFECTS]" header and \n\n
	var lines = []
	
	for effect_name in active_statuses.keys():
		var data = active_statuses[effect_name]
		# Using a cleaner format: "Burn: 3 DMG (2 turns)"
		lines.append("• %s: %d DMG (%d turns)" % [effect_name, data["damage"], data["turns"]])
	
	# Join them with a single newline so it looks like a clean list
	return "\n".join(lines)


# statusComponent.gd

func process_statuses():
	if active_statuses.is_empty():
		processing_finished.emit() # Still emit so the GameManager isn't stuck
		return

	var status_names = active_statuses.keys()
	var parent = get_parent()
	var to_remove = []
	
	for effect_name in status_names:
		if not active_statuses.has(effect_name): continue
		if parent.health <= 0: break

		var data = active_statuses[effect_name]
		
		# Apply Damage
		if parent.has_method("takeDamage"):
			parent.takeDamage(data["damage"])
			if parent.has_method("Feedback"):
				parent.Feedback(parent.global_position, data["damage"], effect_name)
		
		# This is the "Safety Wait"
		# Instead of get_tree(), we use a local timer to avoid scene-tree conflicts
		await get_tree().create_timer(0.6).timeout
		
		data["turns"] -= 1
		if data["turns"] <= 0:
			to_remove.append(effect_name)
			
	for effect in to_remove:
		active_statuses.erase(effect)
	
	processing_finished.emit() # Tell the Player we are done

func get_total_reduction() -> int:
	var total = 0
	for effect in active_statuses.values():
		if effect.has("reduction"):
			total += effect["reduction"]
	return total
