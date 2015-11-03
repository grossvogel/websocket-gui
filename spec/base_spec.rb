#	the example loads dependencies AND gives us an example class to test
require File.expand_path('../../examples/example', __FILE__)

describe ExampleWebSocketApp do

	it { should respond_to(:run!) }
	it { should respond_to(:socket_send) }
	it { should respond_to(:socket_close) }

	context "override Base defaults" do
		let(:example) {
			ExampleWebSocketApp.new(http_port: 80, http_host: "localhost")
		}
		let(:config) { example.websocket_config }

		it "has a config hash" do
			config.should be_an_instance_of(Hash)
		end

		it "has defaults inherited from Base" do
			config[:socket_port].should equal(8080)
			config[:socket_host].should match('127.0.0.1')
		end

		it "overrides defaults in subclass definition" do
			config[:tick_interval].should equal(5)
			config[:on_tick].should be_a_kind_of(Proc)
		end

		it "overrides defaults in constructor" do
			config[:http_port].should equal(80)
			config[:http_host].should match('localhost')
		end
	end

	context "override subclass defaults" do
		let(:example) {
			ExampleWebSocketApp.new(tick_interval: 1)
		}
		let(:config) { example.websocket_config }

		it "overrides already overridden defaults in constructor" do
			config[:tick_interval].should equal(1)
		end
	end
	
end
