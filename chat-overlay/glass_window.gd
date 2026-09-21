## Connects to Streamer.bot WebSocket server and sends chat messages through to ChatBox
## WebSocket connection code written with AI assistance
extends Control

# Streamer.bot WebSocket connection settings
const WS_URL := "ws://127.0.0.1:8080/"

signal chat_message_received(username: String, message: String, raw_data: Dictionary)

var socket := WebSocketPeer.new()
var was_connected := false
var subscribed := false

@export var chat_box : VBoxContainer


func _ready() -> void:
	var err := socket.connect_to_url(WS_URL)
	if err != OK:
		print("Error connecting to Streamer.bot: ", err)
		set_process(false)


func _process(_delta: float) -> void:
	socket.poll()

	var state := socket.get_ready_state()

	match state:
		WebSocketPeer.STATE_OPEN:
			if not was_connected:
				was_connected = true
				print("Connected to Streamer.bot WebSocket server.")
				_subscribe_to_chat()

			while socket.get_available_packet_count() > 0:
				var packet := socket.get_packet()
				var message := packet.get_string_from_utf8()
				_handle_message(message)

		WebSocketPeer.STATE_CLOSING:
			pass

		WebSocketPeer.STATE_CLOSED:
			var code := socket.get_close_code()
			var reason := socket.get_close_reason()
			print("WebSocket closed. Code: %d, Reason: %s" % [code, reason])
			set_process(false)


func _subscribe_to_chat() -> void:
	var subscribe_request := {
		"request": "Subscribe",
		"id": "chat-overlay-subscribe",
		"events": {
			"Twitch": ["ChatMessage"]#,
		#	"YouTube": ["ChatMessage"]
		}
	}

	var json_string := JSON.stringify(subscribe_request)
	socket.send_text(json_string)
	subscribed = true
	print("Sent chat subscription request.")


func _handle_message(message: String) -> void:
	var json := JSON.new()
	var parse_result := json.parse(message)
	if parse_result != OK:
		print("Failed to parse JSON: ", json.get_error_message())
		return

	var data = json.get_data()
	if typeof(data) != TYPE_DICTIONARY:
		return

	# Subscription confirmation responses will have "status"/"id" but no "event"
	if data.has("event"):
		_handle_event(data)


func _handle_event(data: Dictionary) -> void:
	var event_info: Dictionary = data.get("event", {})
	var event_type: String = event_info.get("type", "")
	var event_source: String = event_info.get("source", "")

	if event_type != "ChatMessage":
		return
	
	chat_box.create_chat_message(data.get("data", {}), event_source)
