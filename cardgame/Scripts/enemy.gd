extends CharacterBody2D
@export var health :int 
@onready var player :Node = get_tree().get_first_node_in_group("Player")
var attackWheelValue :int
var modifiedDamage :int = 0
@export var Description :String
@export var Name :String


func _ready():
	gameManager.Enemy = self

#func _input(event):
	#if event.is_action_pressed("Space"):
		#Attack()

func _physics_process(delta):
	if Input.is_action_just_pressed("Space"):
		Attack()
		print("Attack")

func takeDamage(damage: int):
	health -= damage
	gameManager.hideenemyDescription()
	print("Enemy health is ", health, "The enemy was dealth ", damage, "damage")

func dealDamage(amount: int):
	if modifiedDamage <= 0:
		amount += modifiedDamage
		player.takeDamage(amount)
		Feedback(player.global_position, amount, "damage")
		modifiedDamage = 0
	else:
		player.takeDamage(amount)

func buffDamage(amount: int):
	modifiedDamage += amount
	Feedback(self.global_position, amount, "buff")
	gameManager.hideenemyDescription()

func heal(amount):
	health += amount
	Feedback(self.global_position, amount, "heal")
	gameManager.hideenemyDescription()

func Attack():
	spinWheel()
	match attackWheelValue:
		1:
			dealDamage(4)
		2:
			buffDamage(2)
		3:
			heal(3)
		4:
			dealDamage(2)
			await get_tree().create_timer(.5).timeout
			buffDamage(3)
		5: 
			dealDamage(3)
			await get_tree().create_timer(.5).timeout
			buffDamage(2)
	gameManager.endEnemyTurn()

	
func spinWheel():
	attackWheelValue = randi_range(1, 5)
	return attackWheelValue
	
func attackOne():
	dealDamage(4)
	
func attackTwo():
	buffDamage(2)
	#modifiedDamage = 2
	
func attackThree():
	heal(3)
	
func attackFour():
	dealDamage(2)
	await get_tree().create_timer(.25).timeout
	buffDamage(4)

func Feedback(targetPosition: Vector2, amount: int, type: String):
	var offset :Vector2 = Vector2(-40, -90)
	var feedback = preload("res://feedBack.tscn").instantiate()
	feedback.showFeedback(amount, type)
	feedback.global_position = targetPosition + offset
	get_tree().current_scene.add_child(feedback)

func showDescription():
	gameManager.showenemyDescription(self)
	
func hideDescription():
	gameManager.hideenemyDescription()
