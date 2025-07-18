extends CharacterBody2D

var health: int = 10
var armor: int = 0
var Name: String = "Warrior"
var temp_modDamage: int = 0



func takeDamage(damage :int):
	health = (damage - armor) - health
	EventBus.emit_signal("takenDamage", Name)
	
	
func temp_modifyDamage(baseDamage):
	var newDamage = temp_modDamage + baseDamage
	temp_modDamage = 0
	return newDamage
	
func gainArmor(amount: int):
	print ("works again")
	armor += amount
	print(armor)

