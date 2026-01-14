extends Node

var library = {
	"Rat": {
		"scene": "res://Enemies/Rat.tscn",
		"value": 1,
		"tier": "common"
	},
	"Wolf": {
		"scene": "res://Enemies/Wolf.tscn",
		"value": 2,
		"tier": "common",
	},
	"smallWizardGoblin": {
		"scene": "res://Enemies/small_WizardGoblin.tscn",
		"value": 4,
		"tier": "common",
	},
	"smallWarriorGoblin": {
		"scene": "res://Enemies/smallWarriorGoblin.tscn",
		"value": 3,
		"tier": "common",
	},
	"smallArcherGoblin": {
		"scene": "res://Enemies/smallArcherGoblin.tscn",
		"value": 4,
		"tier": "common",
	},
	"skellyWarrior": {
		"scene": "res://Enemies/warriorSkeleton.tscn",
		"value": 5,
		"tier": "common",
	},
	"skellyArcher": {
		"scene": "res://Enemies/skellyArcher.tscn",
		"value": 5,
		"tier": "common",
	},
	"bigWarriorGoblin": {
		"scene": "res://Enemies/bigWarriorGoblin.tscn",
		"value": 5,
		"tier": "Uncommon",
	},
	"Minotaur": {
		"scene": "res://Enemies/minotaur.tscn",
		"value": 6,
		"tier": "Uncommon",
	},
	"skellyMenace": {
		"scene": "res://Enemies/skellyMenace.tscn",
		"value": 7,
		"tier": "Uncommon",
	},
	"snakeMan": {
		"scene": "res://Enemies/snakeMan.tscn",
		"value": 8,
		"tier": "Uncommon",
	},
	"Wendigo": {
		"scene": "res://Enemies/Wendigo.tscn",
		"value": 9,
		"tier": "Uncommon",
	}
}


func get_encounter_scenes(budget: int) -> Array[PackedScene]:
	var scenes : Array[PackedScene] = []
	var current_budget = budget
	
	# Get all enemy keys and shuffle them for variety
	var enemy_names = library.keys()
	enemy_names.shuffle()
	
	# We try to fill the team, but stop if we run out of money
	# or reach the 4-enemy limit (based on your markers)
	for i in range(4):
		var found_enemy = false
		for name in enemy_names:
			var data = library[name]
			# If we can afford it, add it
			if data["value"] <= current_budget:
				var scene = load(data["scene"])
				scenes.append(scene)
				current_budget -= data["value"]
				found_enemy = true
				break 
		
		if not found_enemy:
			break # Nothing left we can afford
			
	return scenes
