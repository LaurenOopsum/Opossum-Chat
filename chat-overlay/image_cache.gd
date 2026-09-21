## Displays emotes
## Written by AI while troubleshooting my own code
extends Node

const CACHE_DIR := "user://image_cache"

signal _finished(url: String)

var _textures: Dictionary = {}   # url -> Texture2D
var _in_flight: Dictionary = {}  # url -> true


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(CACHE_DIR)


func get_texture(url: String) -> Texture2D:
	if url.is_empty():
		return null
	if _textures.has(url):
		return _textures[url]

	# Cached on disk from a previous run?
	var path := "%s/%s.bin" % [CACHE_DIR, url.md5_text()]
	if FileAccess.file_exists(path):
		var cached := _texture_from_bytes(FileAccess.get_file_as_bytes(path))
		if cached:
			_textures[url] = cached
			return cached

	# Already downloading? Wait for it instead of starting a second request.
	if _in_flight.has(url):
		while _in_flight.has(url):
			await _finished
		return _textures.get(url)

	# Download it.
	_in_flight[url] = true
	var http := HTTPRequest.new()
	add_child(http)
	if http.request(url) == OK:
		var res: Array = await http.request_completed  # [result, code, headers, body]
		if res[0] == HTTPRequest.RESULT_SUCCESS and res[1] == 200:
			var body: PackedByteArray = res[3]
			var tex := _texture_from_bytes(body)
			if tex:
				_textures[url] = tex
				var f := FileAccess.open(path, FileAccess.WRITE)
				if f:
					f.store_buffer(body)
	else:
		push_error("Could not start request for %s" % url)
	http.queue_free()
	_in_flight.erase(url)
	_finished.emit(url)
	return _textures.get(url)


func _texture_from_bytes(bytes: PackedByteArray) -> Texture2D:
	if bytes.size() < 6:
		return null

	# GIF files start with "GIF87a" or "GIF89a"
	if bytes.slice(0, 3).get_string_from_ascii() == "GIF":
		return GifManager.animated_texture_from_buffer(bytes)  # verify name in the addon README

	var img := Image.new()
	if img.load_png_from_buffer(bytes) != OK \
			and img.load_webp_from_buffer(bytes) != OK \
			and img.load_jpg_from_buffer(bytes) != OK:
		return null
	return ImageTexture.create_from_image(img)
