
const CARDS = { # Attack, Health, Card type, Ability script, Ability text
	"Knight" : [2, 3, "Monster", null, null],
	"Archer" : [1, 1, "Monster", "res://Scripts/Abilities/Arrow.gd", "Deal 1 damage to opponent when played."],
	"Demon" : [5, 7, "Monster", "res://Scripts/Abilities/AttackTwice.gd", "If this card attacks, it can attack once again."],
	"Tornado" : [null, null, "Magic", "res://Scripts/Abilities/Tornado.gd", "Deal 1 damage to all opponent cards."]
}
