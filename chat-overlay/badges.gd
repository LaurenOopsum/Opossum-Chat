## Displays chatter badges
extends RichTextLabel

func set_badges(badge_data: Array) :
	clear()
	for badge in badge_data:
		var tex: Texture2D = await ImageCache.get_texture(badge.get("imageUrl", ""))
		if tex: add_image(tex, 0, 18)
	
