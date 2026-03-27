extends Node

const ABILITY_TRIGGER_EVENT = "card_placed"

const TORNADO_DAMAGE = 1

func trigger_ability(battle_manager_reference, card_with_ability, input_manager_reference, trigger_event):
	
	if ABILITY_TRIGGER_EVENT != trigger_event:
		return
	
	input_manager_reference.inputs_disabled = true
	battle_manager_reference.end_turn_button_enabled(false)
	
	await battle_manager_reference.wait(1.0)
	var cards_to_destory = []
	
	for card in battle_manager_reference.opponent_cards_on_battlefield:
		card.health = max(0, card.health - TORNADO_DAMAGE)
		card.get_node("Health").text = str(card.health)
		if card.health == 0:
			cards_to_destory.append(card)
	
	await battle_manager_reference.wait(1.0)
	if cards_to_destory.size() > 0:
		for card in cards_to_destory:
			battle_manager_reference.destroy_card(card, "Opponent")
	
	battle_manager_reference.destroy_card(card_with_ability, "Player")
	await battle_manager_reference.wait(1.0)
	
	input_manager_reference.inputs_disabled = false
	battle_manager_reference.end_turn_button_enabled(true)

func end_turn_reset():
	pass
