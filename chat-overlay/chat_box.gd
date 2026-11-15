## Holds and displays ChatMessages
extends VBoxContainer

var message_visible_seconds := 60.0
var packed_message_scene : PackedScene

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	PassthroughManager.register_interactive(self)
	connect("child_entered_tree", _on_child_entered_tree)

func create_chat_message(message_data : Dictionary, event_source : String) :
	## TwitchMessage currently set as default script for the PackedScene
	var message_scene : ChatMessage = load("res://message/chat_message.tscn").instantiate()
	message_scene.create_thyself(message_data, event_source)
	add_child(message_scene)


func _exit_tree() -> void:
	PassthroughManager.unregister_interactive(self)


func _on_child_entered_tree(child_node:Node) :
	await get_tree().process_frame
	get_parent().scroll_down()
	var visibility_timer := get_tree().create_timer(message_visible_seconds)
	visibility_timer.timeout.connect(_fade_out_chat_message.bind(child_node))


func _fade_out_chat_message(chat_message) :
	if is_instance_valid(chat_message) && chat_message.get_parent() == self :
		chat_message.fade_out()
