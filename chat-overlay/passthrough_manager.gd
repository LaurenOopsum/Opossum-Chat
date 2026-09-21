## Lets the mouse click through the transparent window
## I can't remember if this was written by AI or if it's part of the extension I used, but I didn't write it
extends Node

var is_dragging: bool = false
var interactive_nodes: Array[Control] = []
var _currently_intercepting: bool = false

func _ready() -> void:
	get_window().transparent = true
	get_window().borderless = true
	get_window().focus_entered.connect(_on_focus_entered)
	_apply_passthrough(false)  # start fully click-through

func _on_focus_entered() -> void:
	get_window().transparent = false
	get_window().transparent = true

func register_interactive(node: Control) -> void:
	if node not in interactive_nodes:
		interactive_nodes.append(node)

func unregister_interactive(node: Control) -> void:
	interactive_nodes.erase(node)

func set_dragging(dragging: bool) -> void:
	is_dragging = dragging

func _process(_delta: float) -> void:
	var should_intercept := is_dragging or _mouse_over_any_interactive()
	if should_intercept != _currently_intercepting:
		_apply_passthrough(should_intercept)

func _mouse_over_any_interactive() -> bool:
	var mouse_screen_pos: Vector2 = DisplayServer.mouse_get_position()
	var window_pos: Vector2 = DisplayServer.window_get_position()
	var mouse_window_pos: Vector2 = mouse_screen_pos - window_pos

	for node in interactive_nodes:
		if is_instance_valid(node) and node.visible and node.get_global_rect().has_point(mouse_window_pos):
			return true
	return false

func _apply_passthrough(intercept: bool) -> void:
	_currently_intercepting = intercept
	if Engine.has_singleton("MousePassthrough"):
		Engine.get_singleton("MousePassthrough").set_passthrough(
			get_window().get_window_id(), not intercept
		)
