extends Node2D
@export var health :int 
@onready var player :Node = get_tree().get_first_node_in_group("Player")
var attackWheelValue: int
var modifiedDamage:int = 0


func _input(event):
	if event.is_action_pressed("Space"):
		Attack()

func takeDamage(damage: int):
	health -= damage
	print("Enemy health is ", health, "The enemy was dealth ", damage, "damage")

func dealDamage(amount: int):
	if modifiedDamage <= 0:
		amount += modifiedDamage
		player.takeDamage(amount)
		modifiedDamage = 0
	else:
		player.takeDamage(amount)

func Attack():
	spinWheel()
	match attackWheelValue:
		1:
			attackOne()
		2:
			attackTwo()
		3:
			attackThree()
		4:
			attackFour()

	
func spinWheel():
	attackWheelValue = randi_range(1, 4)
	return attackWheelValue
	
func attackOne():
	dealDamage(3)
	
func attackTwo():
	modifiedDamage = 2
	
func attackThree():
	health += 2
	
func attackFour():
	dealDamage(2)
	modifiedDamage = 3
