extends CharacterBody2D
class_name Player


@export var health: int 
var armor: int = 0
@export var Name: String 
var temp_modDamage: int = 0
@export var AP: int  
var deckList :={}
var drawPile: Array[PackedScene] = []
var wasHurt: bool = false
@export var intelligence: int 
@export var handComponent: Node2D
@export var attackLength: float
@export var animTree: AnimationTree
@export var particles: GPUParticles2D
@export var statusComponent: Node2D


func _ready():
	pass

func takeDamage(damage :int):
	hurtAnim()
	if damage > 0:
		wasHurt = true
	if armor >= 0:
		var newDamage = (damage - armor)
		if newDamage >= armor:
			armor = 0
			health -= newDamage
		else:
			armor = (armor - damage)
	else:
		health -= damage
	if armor < 0:
		armor = 0
	EventBus.emit_signal("takenDamage", Name)
		
func temp_modifyDamage(baseDamage):
	var newDamage = temp_modDamage + baseDamage
	temp_modDamage = 0
	return newDamage
	
func gainArmor(amount: int):
	print ("works again")
	armor += amount
	print(armor)

func armorCheck():
	if armor >= 10:
		EventBus.emit_signal("newAP_Cost", 1)


func showDescription():
	var status_info = ""
	if statusComponent:
		status_info = statusComponent.get_status_description()
		print("Player Status Info: ", status_info) # Debug check
	
	gameManager.showplayerDescription(self, status_info)

func hideDescription():
	gameManager.hideplayerDescription()

func attackAnim():
	print("why no work")
	animTree.set("parameters/conditions/Attack", true)
	await get_tree().create_timer(attackLength).timeout
	animTree.set("parameters/conditions/Attack", false)

func hurtAnim():
	animTree.set("parameters/conditions/Hurt", true)
	await get_tree().create_timer(.35).timeout
	animTree.set("parameters/conditions/Hurt", false)
	
func emitArmor():
	particles.modulate= Color(1,1,1)
	particles.emitting = true
	await get_tree().create_timer(.5).timeout
	particles.emitting = false
	
func emitBuff():
	particles.modulate= Color(1,0,0)
	particles.emitting = true
	await get_tree().create_timer(.5).timeout
	particles.emitting = false


func start_turn():
	print(Name, " starting turn processing...")
	if statusComponent:
		# YOU MUST AWAIT THIS CALL
		await statusComponent.process_statuses()
	
	# Small extra safety gap
	await get_tree().process_frame 
	print(Name, " processing finished.")
	

func Feedback(targetPosition: Vector2, amount: int, type: String):
	var offset :Vector2 = Vector2(0, -90)
	var feedback = preload("res://feedBack.tscn").instantiate()
	feedback.showFeedback(amount, type)
	feedback.global_position = targetPosition + offset
	get_tree().current_scene.add_child(feedback)
