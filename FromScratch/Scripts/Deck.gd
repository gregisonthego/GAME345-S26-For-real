extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2
const STARTING_HAND_SIZE = 5

var player_deck = ["DeckA1", "DeckA2", "DeckA3", "DeckA4",
 "DeckA5", "DeckA6", "DeckA7", "DeckA8", "DeckA9", "DeckAVP"]
var card_database_reference
var drawn_card_this_turn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	card_database_reference = preload("res://Scripts/CardDatabase.gd")
	for i in range(STARTING_HAND_SIZE):
		draw_card()
		drawn_card_this_turn = false
	drawn_card_this_turn = true


func draw_card():
	if drawn_card_this_turn:
		return
	
	drawn_card_this_turn = true
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)
	
	# If player drew the last card in the deck, disable the deck
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://Assets/" + card_drawn_name + "Card.png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.card_tag = card_database_reference.CARDS[card_drawn_name][3]
	if new_card.card_tag == "Versatile":
		new_card.attack = card_database_reference.CARDS[card_drawn_name][0]
		new_card.get_node("Attack").text = str(new_card.attack)
		new_card.speed = card_database_reference.CARDS[card_drawn_name][1]
		new_card.get_node("Speed").text = str(new_card.speed)
		new_card.get_node("VictoryPointValue").visible = false
	elif new_card.card_tag == "Victory_Point":
		new_card.get_node("Attack").visible = false
		new_card.get_node("Speed").visible = false
		new_card.victory_point_value = card_database_reference.CARDS[card_drawn_name][2]
		new_card.get_node("VictoryPointValue").text = str(new_card.victory_point_value)
	
	# If card abilities exist in the future, uncomment the code below by highlighting it and pressing CTRL+K
	#var new_card_ability_script_path = card_database_reference.CARDS[card_drawn_name][4]
	#if new_card_ability_script_path:
		#new_card.ability_script = load(new_card_ability_script_path).new()
		#new_card.get_node("Ability").text = card_database_reference.CARDS[card_drawn_name][5]
	#else:
		#new_card.get_node("Ability").visible = false
	
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("card_flip")

func reset_draw():
	drawn_card_this_turn = false
