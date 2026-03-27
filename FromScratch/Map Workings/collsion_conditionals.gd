extends Node2D

var is_moving := false 
var target_position: Vector2 # the position we want the pawn to move to
var current_node: Node2D = null #the board node(spot) the pawn is currently on

func move_to_node(node: Node2D) -> void:
	target_position = node.global_position #save the world position of the destination node
	current_node = node #update which node we are "on" 
	is_moving = true #turn on movement so physics process starts running
	
#this runs every physics frame
func _physics_process(delta: float) -> void:
	if is_moving:
		#move toward the target position
		global_position = global_position.move_toward(target_position, 200 * delta)
		
		#check if we are close enough to "snap" to the node(spot)
		if global_position.distance_to(target_position) < 1.0:
			global_position = target_position #snap exactly to target spot
			is_moving = false #stop movement
			
			#IMPORTANT:
			#wait one frame before checking collisions
			#because overlap data is not updated instantly 
			call_deferred("check_pawn_collision")
			
func check_pawn_collision() -> void:
	#look at all Area2D nodes overlapping this pawn's Area2D
	
	for area in $Sprite2D/Area2D.get_overlapping_areas():
		#navigate up to the scene tree to find OTHER pawn
		var other_pawn = area.get_parent().get_parent()
		#area -> Sprite2D -> Pawn
		
		if other_pawn != self and other_pawn.is_in_group("pawns"):
			print("Pawn collision with: ", other_pawn.name)
			handle_pawn_collision(other_pawn)
			
func handle_pawn_collision(other_pawn: Node) -> void:
	#where the game rules will go
	print("Start combat or deny space")
