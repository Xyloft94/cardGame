extends CharacterBody2D
class_name Enemy
@export var health :int 
@onready var player :Node = get_tree().get_first_node_in_group("Player")
var attackWheelValue :int
var modifiedDamage :int = 0
var attackFunctions: Array[Callable] = []
@export var Description :String
@export var Name :String
@export var wheelSize :int
@export var animTree: AnimationTree
@export var attackLength: float
@export var hitLength: float
@export var particles: GPUParticles2D
@export var slot: int
@export var side: String


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
	hitAnim()
	health -= damage
	#gameManager.hideenemyDescription()
	
	Feedback(self.global_position, damage, "damage")
	print("Enemy health is ", health, "The enemy was dealth ", damage, "damage")

func dealDamage(amount: int):
	if modifiedDamage <= 0:
		amount += modifiedDamage
		attackAnim()
		await get_tree().create_timer(attackLength).timeout
		player.takeDamage(amount)
		Feedback(player.global_position, amount, "damage")
		modifiedDamage = 0
	else:
		attackAnim()
		await get_tree().create_timer(attackLength).timeout
		player.takeDamage(amount)
		Feedback(player.global_position, amount, "damage")
		player.takeDamage(amount)

func buffDamage(amount: int):
	modifiedDamage += amount
	emitBuff()
	Feedback(self.global_position, amount, "buff")
	gameManager.hideenemyDescription()

func heal(amount):
	health += amount
	emitHealth()
	Feedback(self.global_position, amount, "heal")
	gameManager.hideenemyDescription()

func Attack():
	var result = spinWheel()
	
	if result <= attackFunctions.size():
		await attackFunctions[result -1].call()
	#match attackWheelValue:
		#1:
			#dealDamage(4)
		#2:
			#buffDamage(2)
		#3:
			#heal(3)
		#4:
			#dealDamage(2)
			#await get_tree().create_timer(.5).timeout
			#buffDamage(3)
		#5: 
			#dealDamage(3)
			#await get_tree().create_timer(.5).timeout
			#buffDamage(2)
	gameManager.endEnemyTurn()

	
func spinWheel():
	attackWheelValue = randi_range(1, wheelSize)
	return attackWheelValue
	
func attackOne():
	dealDamage(4)
	print("1")
	
func attackTwo():
	buffDamage(2)
	print("2")
	#modifiedDamage = 2
	
func attackThree():
	heal(3)
	print("3")
	
func attackFour():
	dealDamage(2)
	await get_tree().create_timer(.25).timeout
	buffDamage(4)
	print("4")

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
	
func attackAnim():
	print("should be working")
	animTree.set("parameters/conditions/Attack", true)
	await get_tree().create_timer(attackLength).timeout
	animTree.set("parameters/conditions/Attack", false)
	
func hitAnim():
	animTree.set("parameters/conditions/Hit", true)
	await get_tree().create_timer(hitLength).timeout
	animTree.set("parameters/conditions/Hit", false)
	
func emitArmor():
	particles.modulate= Color(1,1,1)
	particles.emitting = true
	await get_tree().create_timer(.5).timeout
	particles.emitting = false
	
func emitHealth():
	particles.modulate= Color(0,0,1)
	particles.emitting = true
	await get_tree().create_timer(.5).timeout
	particles.emitting = false
	
func emitBuff():
	particles.modulate= Color(1,0,0)
	particles.emitting = true
	await get_tree().create_timer(.5).timeout
	particles.emitting = false
