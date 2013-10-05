#	Websocket Gui
This gem uses Sinatra, EventMachine, and WebSockets to make it easy to use the browser as a GUI for Ruby apps that
would otherwise be stuck in the console.


##	Using Websocket Gui
To use this gem, make a class that extends WebsocketGui::Base and a HTML/JS file to serve as the GUI. 


### Configuration
The following configuration options are available:
* :socket_port 		(8080)
* :socket_host 		(127.0.0.1)
* :http_port		(3000)
* :http_host		(127.0.0.1)
* :view			(:index)
* :tick_interval	(nil)

The options can be set in several ways, each level overriding the previous:
1 In declaring your subclass of WebsocketGui::Base (like tick\_interval below)
1 By passing an options hash to the initializer 
1 By passing an options hash to the run! method


###	Sample Code: project-root/app.rb
	require 'websocket-gui'

	class App < WebsocketGui::Base

		#	specify the name of the file containing the HTML of the app (this is a single-page app)
		#	ex. Look in root directory for frontendfile.erb instead of index.erb (which is the default)
		#view :frontendfile
	
		#	set the time (seconds) between calls to 'on_tick'
		#	if nil (default), on_tick will not fire
		tick_interval 0.1 

		#	code for the on_tick event
		on_tick do |connected|
			@tick_block.call(connected)
		end

		#	code for the on_socket_open event
		on_socket_open do |handshake|
			socket_send "Welcome!!!"
			puts "Client connection opened:"
			puts "#{handshake.inspect}"
		end

		#	code for the on_socket_recv event
		on_socket_recv do |msg|
			puts "Received message from client: #{msg.strip}"
			socket_send "I received your message: #{msg.strip}"
		end

		#	code for the on_socket_close event
		on_socket_close do
			puts "Socket closed."
		end
	end

	#	specify options in the constructor and/or the run method. 
	instance = App.new http_port: 3000, http_host: '127.0.0.1'
	instance.run! socket_port: 8080, socket_host: '127.0.0.1'



###	Sample Code: project-root/index.erb

	<!doctype html>
	<html>
		<head>
			<title>Test Web Sockets</title>
			<meta charset="utf-8" />
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
		</head>

		<body>
			<div id="connectedContainer" style="display:none;">
				<textarea id="input"></textarea>
				<input type="button" id="send" value="Send" />

				<ul id="output"></ul>
				<input type="button" id="disconnect" value="Disconnect" />
			</div>
			<div id="notConnectedContainer">
				<input type="button" id="connect" value="Connect" />
			</div>
			<script type="text/javascript">
				var socket;
				var connect = function () {
					socket = new WebSocket("ws://localhost:8080");
					var writeMessage = function (msg) {
						$("<li></li>").text (msg).appendTo ($("#output"));
					};
					socket.onmessage = function (evt) {
						writeMessage (evt.data);
					};
					socket.onclose = function () { 
						writeMessage ("Socket Closed!"); 
						$("#connectedContainer").hide ();
						$("#notConnectedContainer").show();
						$("#output li").remove ();
					}
					socket.onopen = function () { 
						writeMessage ("Socket Opened!"); 
						$("#connectedContainer").show ();
						$("#notConnectedContainer").hide ();
					}
					$("#send").on ('click', function () {
						var input = $("#input");
						if (input.val ())
						{
							socket.send(input.val ());
							input.val ('');
						}
					});
				}
				$("#connect").on ('click', function () { connect (); } );
				$("#disconnect").on ('click', function () { socket.close (); });
				
			</script>
		</body>
	</html>


## 	file structure
	project-root/
		app.rb
		index.erb
		... (up to you)


## 	running the app (from the project dir)
	$ ruby app.rb

	This will start the socket server and sinatra, and launch a browser with your view.


## todo
* Create a small JS library that wraps the native websocket and makes it easy to post events to the server.
* Expand event handlers so you can write events like `on_start do |params|` instead of having to do parse raw strings and do everything in on\_socket\_recv

