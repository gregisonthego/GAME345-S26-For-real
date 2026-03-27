extends Node

const ABILITY_TRIGGER_EVENT = "card_placed"

const ARROW_DAMAGE = 1

func trigger_ability(battle_manager_reference, card_with_ability, input_manager_reference, trigger_event):
	
	if ABILITY_TRIGGER_EVENT != trigger_event:
		return
	
	input_manager_reference.inputs_disabled = true
	battle_manager_reference.end_turn_button_enabled(false)
	
	await battle_manager_reference.wait(1.0)
	
	battle_manager_reference.direct_damage(ARROW_DAMAGE)
	
	await battle_manager_reference.wait(1.0)
	
	input_manager_reference.inputs_disabled = false
	battle_manager_reference.end_turn_button_enabled(true)

func end_turn_reset():
	pass
