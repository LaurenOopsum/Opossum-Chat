## Subclass of ChatMessage specifically for messages from Twitch
class_name TwitchMessage extends ChatMessage

var message_id : String
var anonymous : bool
var meta : Dictionary


func create_thyself(data:Dictionary) :
	message_id = data.get("messageId", "")
	anonymous = data.get("anonymous", false)
	meta = data.get("meta", {})
	
	%User.set_user(data.get("user",{}))
	%Message.set_message(data)
	
	if meta.get("firstMessage") && !meta.get("returningChatter") :
		self_modulate = Color.GOLD
	else : self_modulate = Color.BLACK
	
	

 
