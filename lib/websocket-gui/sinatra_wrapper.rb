module WebsocketGui
	class SinatraWrapper < Sinatra::Base
		
		set :views, './'

		get '/' do
			erb self.class.view_path
		end

		def self.view_path
			@view_path || :index
		end

		def self.view_path=(view_path)
			@view_path = view_path.to_sym
		end
	end
end
