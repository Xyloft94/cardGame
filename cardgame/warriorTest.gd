extends CharacterBody2D

var health: int = 10
var armor: int = 0
var Name: String = "Warrior"
var temp_modDamage: int = 0
var AP: int = 3
var deckList :={
	"res://Cards/Slice.tscn": 3,
	"res://Cards/Shield.tscn": 2,
	"res://Cards/Revenge.tscn": 2,
	"res://Cards/Rage.tscn": 2,
	"res://Cards/crushing_blow.tscn": 1,
	"res://Cards/Brace.tscn": 2
}
var drawPile: Array[PackedScene] = []
var intelligence: int = 5
@export var handContainer: Node


func _ready():
	setupDeck()
	drawHand()
	print("Cards in draw pile:")
	for card in drawPile:
		print(card.resource_path)

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

func armorCheck():
	if armor >= 10:
		EventBus.emit_signal("newAP_Cost", 1)
		
func setupDeck():
	for path in deckList.keys():
		var count = deckList[path]
		var cardScene = load(path)
		for i in count:
			drawPile.append(cardScene)
	drawPile.shuffle()
	
func drawHand():
	for i in intelligence:
		drawCard()
		
func drawCard():
	if drawPile.is_empty():
		return
	var cardScene = drawPile.pop_front()
	var card = cardScene.instantiate()
	card.caster = self
	handContainer.add_child(card)
	handContainer.arrangeHand()
