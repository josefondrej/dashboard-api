module V1
  class Servers < Grape::API
    prefix :api
    version 'v1', using: :path
    format :json

    get '/servers/' do
      Servers.all.map(&:to_json)
    end

    params do
      requires :id, type: Integer, desc: 'Database id'
    end
    get '/servers/:id' do
      begin
        server = Server.find_by_id(params[:id])
        if server
          server.to_json
        else
          error!("Server with id #{params[:id]} not found.", 404)
        end
      rescue Exception => e
        error! e.messages
      end

    end

    params do
      requires :id, type: Integer, desc: 'Database id'
    end
    delete '/servers/:id' do
      begin
        server = Server.find_by_id(params[:id])
        if server
          server.destroy
        else
          error!("Server with id #{params[:id]} not found.", 404)
        end
      rescue Exception => e
        error! e.messages
      end

    end

    params do
      requires :url, type: String, desc: 'Server URL'
      requires :name, type: String, desc: 'Server name'
    end
    post '/servers/' do

      begin
        server = Server.new(
          url: params[:url],
          name: params[:name]
        )

        if server.save
          server
        else
          error! server.errors
        end
      rescue Error => e
        error! e.messages
      end
    end

  end
end
