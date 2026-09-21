## Information about the user who sent the chat message
extends HBoxContainer

var role : float
var badges : Array
var color : Color
var subscribed : bool
var subscription_tier : String
var months_subscribed : float
var user_id : String
var login : String
var user_name : String
var type : String


func set_user(user_data:Dictionary) :
	role = user_data.get("role", 0.0)
	badges = user_data.get("badges", [])
	color = Color(user_data.get("color","#1E90FF"))
	subscribed = user_data.get("subscribed", false)
	subscription_tier = user_data.get("subscriptionTier", "0000")
	months_subscribed = user_data.get("monthsSubscribed", 0.0)
	user_id = user_data.get("id", "")
	login = user_data.get("login", "")
	user_name = user_data.get("name", "")
	type = user_data.get("type", "")
	
	$Badges.set_badges(user_data.get("badges",[]))
	set_username()


func set_username() :
	$UserName.text = user_name
	$UserName.self_modulate = color
	## would be fun to add the option for people to choose their own font
