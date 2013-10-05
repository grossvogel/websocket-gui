require File.expand_path('../../examples/example', __FILE__)

describe ExampleWebSocketApp do
	let(:example) {
		ExampleWebSocketApp.new(http_port: 80, http_host: "localhost")
	}
	let(:config) { example.config }

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

	it "overrides already overridden defaults in constructor" do
		overrider = ExampleWebSocketApp.new(tick_interval: 1)
		overrider.config[:tick_interval].should equal(1)
	end

end
