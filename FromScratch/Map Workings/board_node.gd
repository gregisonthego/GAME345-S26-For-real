extends Node2D

#these store references to the neighboring nodes
var up = null
var down = null
var left = null
var right = null

#this variable allows us to block movement for later (i.e. walls, enemies, etc.)
var is_blocked = false

#keeps track of whether this node is highlighted
var is_highlighted = false

#this function returns a neighbor node based on direction
func get_neighbor(direction: String):
	match direction:
		"up":
			return up
		"down":
			return down
		"left":
			return left
		"right":
			return right
		#if direction doesn't match anaything, return nothing
		_:
			return null

#this function stores all valid neighboring nodes in an array
func get_all_neighbors():
	var neighbors = []
	
	if up != null and not up.is_blocked:
		#append is used to add a new element to the end of an array
		neighbors.append(up)
		
	if down != null and not down.is_blocked:
		neighbors.append(down)
		
	if left != null and not left.is_blocked:
		neighbors.append(left)
		
	if right != null and not right.is_blocked:
		neighbors.append(right)
	
	return neighbors
	
#highlight the nodes based on movement input
func set_highlight(active: bool):
	#save highlight state
	is_highlighted = active
	#get the nodes sprite
	var sprite = $Sprite2D
	
	#change appearance depending on highlight state
	if active:
		#modulate allows us to change the color across all nodes on a canvas
		#slight blue opaque tint for highlighted nodes
		sprite.modulate = Color(0.4, 0.6, 1.5, 0.8)
	else:
		#set to normal color
		sprite.modulate = Color(1,1,1,1)
	
