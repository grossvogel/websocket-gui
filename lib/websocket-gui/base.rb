module WebsocketGui
	
	class Base

		#	class-level config, so you can wire your settings into your class
		#	These can also be provided when calling run!
		@@websocket_config = {
			socket_port: 8080,
			socket_host: '127.0.0.1',
			http_port: 3000,
			http_host: '127.0.0.1',
			tick_interval: nil,
			view: :index,
		}
		def self.method_missing(method, *args, &block)
			if block_given?
				@@websocket_config[method] = block
			else
				@@websocket_config[method] = args.first
			end
		end

		attr_reader :websocket_config

		def initialize(config = {})
			@websocket_config = @@websocket_config.merge(config)
		end

		#	start the socket server and the web server, and launch a browser to fetch the view from the web server
		def run!(runtime_config = {})
			@websocket_config.merge! runtime_config

			EM.run do
				if @websocket_config[:tick_interval]
					EM.add_periodic_timer(@websocket_config[:tick_interval]) do
						socket_trigger(:on_tick, @socket_connected)
					end
				end

				EventMachine::WebSocket.run(host: @websocket_config[:socket_host], port: @websocket_config[:socket_port]) do |socket|
					@socket_active = socket
					socket.onopen do |handshake|
						@socket_connected = true
						socket_trigger(:on_socket_open, handshake)
					end

					socket.onmessage do |msg| 
						process_message(msg)
					end

					socket.onclose do 
						socket_trigger(:on_socket_close)
						@socket_connected = false 
					end
				end
			 
				Launchy.open("http://#{@websocket_config[:http_host]}:#{@websocket_config[:http_port]}/")
				WebsocketGui::SinatraWrapper.view_path = @websocket_config[:view]
				WebsocketGui::SinatraWrapper.run!(
					port: @websocket_config[:http_port], 
					bind: @websocket_config[:http_host])
			end
		end

		def socket_send(msg)
			@socket_active.send msg if @socket_connected
		end

		def socket_close
			@socket_active.stop if @socket_connected
		end

		private

		def handler_exists?(method)
			@websocket_config[method].kind_of? Proc
		end

		def socket_trigger(method, *args)
			self.instance_exec(*args, &@websocket_config[method]) if handler_exists? method
		end

		def process_message(msg)
			begin
				data = JSON.parse(msg)

				if data && data['event'] && data['params']
					event_method = ('on_' + data['event']).to_sym
					if handler_exists? event_method
						socket_trigger(event_method, data['params'])
						return
					end
				end

				rescue JSON::ParserError
					#	fall through to trigger :on_socket_recv
			end
			
			socket_trigger(:on_socket_recv, msg)
		end
	end
end
