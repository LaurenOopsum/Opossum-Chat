## Holds and displays ChatMessages
extends VBoxContainer

var message_visible_seconds := 30.0
var packed_message_scene : PackedScene

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	PassthroughManager.register_interactive(self)
	connect("child_entered_tree", _on_child_entered_tree)

func create_chat_message(message_data : Dictionary, _event_source : String) :
	## TwitchMessage currently set as default script for the PackedScene
	var message_scene : TwitchMessage = load("res://chat_message.tscn").instantiate()
	## For when I add YouTube
	# match event_source :
		# "Twitch" : message_scene.set_script(load("res://twitch_message.gd"))
		# "YouTube" : message_scene.set_script(load("res://youtube_message.gd"))
	message_scene.create_thyself(message_data)
	add_child(message_scene)


func _exit_tree() -> void:
	PassthroughManager.unregister_interactive(self)


func _on_child_entered_tree(child_node:Node) :
	await get_tree().process_frame
	get_parent().scroll_down()
	var visibility_timer := get_tree().create_timer(message_visible_seconds)
	visibility_timer.timeout.connect(_fade_out_chat_message.bind(child_node))


func _fade_out_chat_message(chat_message:ChatMessage) :
	if chat_message.get_parent() == self :
		chat_message.fade_out()
