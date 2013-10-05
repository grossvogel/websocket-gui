$:.unshift(File.dirname(__FILE__) + '/../lib')

require "em-websocket"
require "sinatra"
require "thin"
require "launchy"

require "websocket-gui/base"
require "websocket-gui/sinatra_wrapper"

