extends Node2D

#this variable keeps track of where the player is
var current_node = null

#TEMPORARY MOVEMENT VARIABLE TESTING!!!!
#variable that determines the amount of spaces the player is allowed to move
var moves_remaining = 0

#variable checking whether the player is currently in movement phase
var movement_active = false

#stores every node visited during the current move
var movement_path = []

#stores the node where the move started
var start_node = null


func _ready():
	#get references to the nodes in the scene
	var node1 = get_node("../Node1")
	var node2 = get_node("../Node2")
	var node3 = get_node("../Node3")
	var node4 = get_node("../Node4")
	var node5 = get_node("../Node5")
	
	#temporary node setup in map 
	
	#node1 -> node2
	node1.right = node2
	
	#node2 <-> node1 & node3
	node2.left = node1
	node2.right = node3
	
	#node3 <-> node2 & node4
	node3.left = node2
	node3.right = node4
	
	#node4 <-> node3 & node=5
	node4.left = node3
	node4.right = node5
	
	#node5 <- node4
	node5.left = node4
	
	#set starting position to first node
	current_node = node1
	print("Starting on: ", current_node.name)
	
	#TEMP TEST(simulating a card giving 3 movement
	start_movement(4)
	
#START MOVEMENT (going to be called by the cards later on)
func start_movement(amount: int):
	moves_remaining = amount
	movement_active = true
	
	#save whereever the movement started
	start_node = current_node
	
	#reset the path and put the starting node in it
	movement_path.clear()
	movement_path.append(current_node)

	print("Movement started with: ", moves_remaining, "spaces")
	#show all spaces the player can reach
	highlight_reachable_nodes()

	
func move_to(direction: String):
	#stop if there is no movement left
	if moves_remaining <= 0:
		print("No moves remaining")
		return
	
	#ask the current node where we are able to move
	var next_node = current_node.get_neighbor(direction)
	
	#if there's no node in chosen direction --> stop
	if next_node == null:
		print("No node in that direction: ", direction)
		return
		
	#if direction/next node is blocked --> stop
	if next_node.is_blocked:
		print("Node is blocked")
		return
		
	#move to the new node
	current_node = next_node
	
	#add this node to the path
	movement_path.append(current_node)
	
	#use one movement point
	moves_remaining -= 1
	
	print("Moved to: ", current_node.name)
	print("Moves remaining: ", moves_remaining)
	print_path()
	
	#refresh highlights after each move
	highlight_reachable_nodes()
	
	
	#end movement when out of moves
	if moves_remaining == 0:
		movement_active = false
		clear_all_highlights()
		print("Movement finished")
		
func print_path():
	#print the path in a readable way
	var path_names = []
	
	for node in movement_path:
		path_names.append(node.name)
	print("Current path: ", path_names)
	
func clear_all_highlights():
	#turn off highlight on every node under BoardRoot
	var board_root = get_parent()
	
	for child in board_root.get_children():
		if child.has_method("set_highlight"):
			child.set_highlight(false)
			
func highlight_reachable_nodes():
	#first remove old highlights
	clear_all_highlights()
	
	#find all nodes reachable wih reamining movement
	var reachable_nodes = get_reachable_nodes(current_node, moves_remaining)
	
	#turn on highlight for each reachable node
	for node in reachable_nodes:
		node.set_highlight(true)

func get_reachable_nodes(from_node, steps):
	#this returns all nodes reachable within a number of steps
	var results = []
	var visited = {}

	find_reachable_recursive(from_node, steps, results, visited)

	#don't count current node as destination
	if results.has(from_node):
		results.erase(from_node)

	return results

func find_reachable_recursive(node, steps, results, visited):
	#stop if node is invalid
	if node == null:
		return

	#build a unique key using the node and remaining step count
	var key = str(node.get_instance_id()) + "_" + str(steps)

	#prevent repeating the same search state
	if visited.has(key):
		return

	visited[key] = true

	#add node to results if it isn't already there
	if not results.has(node):
		results.append(node)

	#stop when no steps remain
	if steps <= 0:
		return

	#search outward through all neighbors
	for neighbor in node.get_all_neighbors():
		find_reachable_recursive(neighbor, steps - 1, results, visited)

func _unhandled_input(event):
	#if not in movement mode, ignore the input
	if not movement_active:
		return
	
	#using built in input actions in godot
	if event.is_action_pressed("ui_up"):
		move_to("up")
	elif event.is_action_pressed("ui_down"):
		move_to("down")
	elif event.is_action_pressed("ui_left"):
		move_to("left")
	elif event.is_action_pressed("ui_right"):
		move_to("right")
