extends Node2D

# The port that the server is listening for communications on
const PORT = 123
# The IP address of the server. If the client is trying to connect to a server on the same computer, use 'localhost'
const SERVER_ADDRESS = "localhost"

# Create multiplayer object called 'peer' using ENet networking library
var peer = ENetMultiplayerPeer.new()

@export var player_field_scene : PackedScene
@export var opponent_field_scene : PackedScene


func _on_host_button_pressed() -> void:
	disable_buttons()
	
	# Create server (Set our multiplayer object 'peer' to a server that listens for communications on PORT)
	peer.create_server(PORT)
	
	# 'multiplayer' is a built-in property of all scenes in Godot (Accessible from anywhere)
	# 'multiplayer_peer' is a property of multiplayer where we can assign the object responsible for networking
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	
	var player_scene = player_field_scene.instantiate()
	add_child(player_scene)


func _on_join_button_pressed() -> void:
	disable_buttons()
	
	# Create client (Set our multiplayer object 'peer' to a client)
	peer.create_client(SERVER_ADDRESS, PORT)
	
	multiplayer.multiplayer_peer = peer
	
	var player_scene = player_field_scene.instantiate()
	add_child(player_scene)
	
	var opponent_scene = opponent_field_scene.instantiate()
	add_child(opponent_scene)
	
	player_scene.client_set_up()


# Called when a client connects to the host (Will only call for the Host)
func _on_peer_connected(peer_id):
	var opponent_scene = opponent_field_scene.instantiate()
	add_child(opponent_scene)
	
	get_node("PlayerField").host_set_up()


func disable_buttons():
	$HostButton.disabled = true
	$HostButton.visible = false
	$JoinButton.disabled = true
	$JoinButton.visible = false
