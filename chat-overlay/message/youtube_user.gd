## Information about the user who sent the chat message
extends HBoxContainer


func set_user(user_data:Dictionary) :
	$UserName.text = user_data.get("name", "")
	$YouTube.visible = true
