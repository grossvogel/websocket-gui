module WebsocketGui
	
	class Base

		#	class-level config, so you can wire your settings into your class
		#	These can also be provided when calling run!
		@@config = {
			socket_port: 8080,
			socket_host: '127.0.0.1',
			http_port: 3000,
			http_host: '127.0.0.1',
			tick_interval: nil,
			view: :index,
		}
		def self.method_missing(method, *args, &block)
			if block_given?
				@@config[method] = block
			else
				@@config[method] = args.first
			end
		end

		attr_reader :config

		def initialize(config = {})
			@config = @@config.merge(config)
		end

		#	start the socket server and the web server, and launch a browser to fetch the view from the web server
		def run!(runtime_config = {})
			@config.merge! runtime_config

			EM.run do
				if @config[:tick_interval]
					EM.add_periodic_timer(@config[:tick_interval]) do
						socket_trigger(:on_tick, @socket_connected)
					end
				end

				EventMachine::WebSocket.run(host: @config[:socket_host], port: @config[:socket_port]) do |socket|
					@socket_active = socket
					socket.onopen do |handshake|
						@socket_connected = true
						socket_trigger(:on_socket_open, handshake)
					end

					socket.onmessage do |msg| 
						socket_trigger(:on_socket_recv, msg)
					end

					socket.onclose do 
						socket_trigger(:on_socket_close)
						@socket_connected = false 
					end
				end
			 
				Launchy.open("http://#{@config[:http_host]}:#{@config[:http_port]}/")
				WebsocketGui::SinatraWrapper.view_path = @config[:view]
				WebsocketGui::SinatraWrapper.run!(
					port: @config[:http_port], 
					bind: @config[:http_host])
			end
		end

		def socket_send(msg)
			@socket_active.send msg if @socket_connected
		end

		def socket_close
			@socket_active.stop if @socket_connected
		end

		private

		def socket_trigger(method, *args)
			self.instance_exec(*args, &@config[method]) if @config[method].kind_of? Proc
		end
	end
end
