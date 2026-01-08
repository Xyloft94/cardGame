extends "res://Scripts/Card.gd"


func play(target: Node):
	caster.attackAnim()
	await damage(3, target)
	apply_dot("Burn", 2, 2, target)
	discard()
