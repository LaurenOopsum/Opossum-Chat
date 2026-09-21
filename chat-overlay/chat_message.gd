## Base class for chat messages.
## Code for dragging was written by AI
class_name ChatMessage extends PanelContainer

const DRAG_THRESHOLD := 6.0  

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var original_parent: Node = null
var original_index: int = -1

var _press_pending: bool = false
var _press_start: Vector2 = Vector2.ZERO


func _ready() :
	for child in get_children():
		_set_filter_recursive(child)
	gui_input.connect(_on_gui_input)
	set_process_input(false)
	set_process(false)


func _enter_tree() :
	PassthroughManager.register_interactive(self)


func _exit_tree() :
	PassthroughManager.unregister_interactive(self)


func _on_gui_input(event: InputEvent) :
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_press_pending = true
				_press_start = event.global_position
				drag_offset = event.global_position - global_position
			else:
				_press_pending = false
				if dragging:
					_stop_drag()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			return_to_chatbox()
	elif event is InputEventMouseMotion and _press_pending and not dragging:
		if event.global_position.distance_to(_press_start) >= DRAG_THRESHOLD:
			_start_drag()


func _input(event: InputEvent) :
	if not dragging:
		return
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position() - drag_offset
	elif event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_stop_drag()
		get_viewport().set_input_as_handled()


func _process(_delta: float) :
	if dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_stop_drag()


func _set_filter_recursive(node: Node) :
	if node is Control:
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for child in node.get_children():
		_set_filter_recursive(child)


func _start_drag() :
	var overlay: Control = get_tree().current_scene as Control
	if overlay == null:
		push_error("current_scene is not a Control — can't reparent for drag")
		return

	dragging = true
	set_process_input(true)
	set_process(true)
	PassthroughManager.set_dragging(true)

	if get_parent() != overlay:
		original_parent = get_parent()
		original_index = get_index()
		reparent(overlay, true)  # keeps global position


func _stop_drag() :
	dragging = false
	_press_pending = false
	set_process_input(false)
	set_process(false)
	PassthroughManager.set_dragging(false)


func return_to_chatbox() :
	if get_parent() == get_tree().current_scene \
			and is_instance_valid(original_parent):
		reparent(original_parent, false)
		original_parent.move_child(self, min(original_index, original_parent.get_child_count() - 1))


func create_thyself(_data: Dictionary) :
	pass


func fade_out() :
	var tween := create_tween()
	tween.tween_property(self,"modulate",Color.TRANSPARENT,0.5)
	await tween.finished
	tween.kill()
