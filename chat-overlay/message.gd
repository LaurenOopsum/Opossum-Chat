## Text of a chat message
## Rewritten by AI while troubleshooting my own code
extends RichTextLabel

func set_message(data: Dictionary) -> void:
	clear()
	var text: String = data.get("text", "")

	# emote name -> image url
	var lookup := {}
	for e in data.get("emotes", []):
		lookup[e.get("name")] = e.get("imageUrl")
		ImageCache.get_texture(e.get("imageUrl", ""))  # no await: start downloads in parallel

	var words := text.split(" ")
	for i in words.size():
		var tex: Texture2D = null
		if lookup.has(words[i]):
			tex = await ImageCache.get_texture(lookup[words[i]])
		if tex:
			add_image(tex, 0, 18)
		else:
			add_text(words[i])
		if i < words.size() - 1:
			add_text(" ")
