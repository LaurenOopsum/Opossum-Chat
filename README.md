## About
This overlay doesn't connect directly to Twitch, it connects to Streamer.bot's WebSocket server using Streamer.bot's default settings. 

## To Run
Before starting this chat overlay, Streamer.bot must be running its WebSocket Server.

**WEBSOCKET SERVER SETTINGS**
- Address: 127.0.0.1
- Port: 8080
- Endpoint: /
- Authentication: Disabled

## Display Settings
Opossum Chat is setup for a screen size of 1920x1080. I don't know how it'll react to different resolutions.

## Functionality
- Drag and drop chat messages from the chat box. They will remain in place and visible on the screen until returned to the chat box, at which point they'll disappear after 30 seconds like all other chat messages do.
- Right click on a chat message to return it to the chat box.

## To Quit
Right click on the icon in the task bar and close the window.
