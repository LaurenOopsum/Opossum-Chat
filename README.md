## About
This overlay doesn't connect directly to Twitch, it connects to Streamer.bot's WebSocket server using Streamer.bot's default settings.

## To Run
Before starting this chat overlay, Streamer.bot must be running its WebSocket Server.

**WEBSOCKET SERVER SETTINGS**
- Address: 127.0.0.1
- Port: 8080
- Endpoint: /
- Authentication: Disabled

Start Opossum Chat once the WebSocket Server is running. It won't look like anything once you've got it started, but if the icon is in the taskbar then it's running.

## OBS
Use the Game Capture source to display Opossum Chat in OBS, *not* Window Capture, and check "Allow Transparency".

## Display Settings
Opossum Chat is setup for a screen size of 1920x1080. I don't know how it'll react to different resolutions.

## Functionality
- Drag and drop chat messages from the chat box. They will remain in place and visible on the screen until returned to the chat box, at which point they'll disappear after 30 seconds like all other chat messages do.
- Right click on a chat message to return it to the chat box.

## Web Access
The chat overlay downloads emotes from Twitch and may request internet access for that purpose. It receives chat message information, including emote URLs, through Streamer.bot and only accesses the internet to download the images at the provided URLs.

## To Quit
Right click on the icon in the task bar and close the window.
