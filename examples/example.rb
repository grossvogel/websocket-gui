require File.expand_path('../../lib/websocket-gui', __FILE__)

class ExampleWebSocketApp < WebsocketGui::Base
	
	tick_interval 5

	on_tick do |connected|
		puts "Tick: " + (connected ? "connected" : "not connected")
		socket_send "Tick"
	end
	
	on_socket_open do |handshake|
		socket_send "Socket opened. Welcome!!!"
		puts "Client connection opened.\n Handshake:\n #{handshake.inspect}"
	end

	on_socket_recv do |msg|
		puts "Received message from client: #{msg.strip}"
		socket_send "I received your message: #{msg.strip}"
	end

	on_socket_close do
		puts "Socket closed."
	end
end

if __FILE__ == $0
	example = ExampleWebSocketApp.new
	example.run!
end
