## Information about the user who sent the chat message
extends HBoxContainer


func set_user(user_data:Dictionary) :
	var color := Color(user_data["color"]) if user_data["color"] != "" else Color.WHITE

	$Badges.set_badges(user_data.get("badges",[]))

	$UserName.text = user_data.get("name", "")
	if color && color != Color.BLACK :
		$UserName.add_theme_color_override("default_color",color)
	## would be fun to add the option for people to choose their own font
