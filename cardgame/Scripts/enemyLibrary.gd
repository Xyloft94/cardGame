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
	var scenes: Array[PackedScene] = []
	var currentBudget = budget
	var enemyNames = library.keys()
	
	for i in range(4):
		enemyNames.shuffle()
		var foundEnemy = false
		for name in enemyNames:
			var data = library[name]
			if data["value"] <= currentBudget:
				var scene = load(data["scene"]) as PackedScene
				scenes.append(scene)
				currentBudget -= data["value"]
				foundEnemy = true
				break 
		
		if not foundEnemy:
			break
	return scenes
