module V1
  class Repositories < Grape::API
    prefix :api
    version 'v1', using: :path
    format :json

    get 'repositories/' do
      Repository.all.map(&:to_json)
    end

    params do
      requires :id, type: Integer, desc: ''
    end
    get 'repositories/:id' do
      begin
        repo = Repository.find_by_id(params[:id])
        if repo
          repo.to_json
        else
          error!("No repository with id #{params[:id]} found.", 404)
        end
      rescue => e
        error! e.message
      end
    end

    # Sample request via CURL
    #
    #   curl -X POST http://localhost:9292/api/v1/repositories \
    #   -H 'accept: application/json' \
    #   -H 'content-type: application/json' \
    #   -d '{
    #  "url": "swissdrg/dashboard",
    #  "deployments":[{"kind":"production", "url":"localhost"}]
    # }'
    params do
      optional :url, type: String, desc: 'Url of target repository'
      optional :deployments, type: Array do
        optional :kind, type: String
        optional :url, type: String
      end
    end
    post '/repositories' do
      begin
        repo = Repository.new(
          url: params[:url],
          deployments_params: params[:deployments]
        )
        if repo.save
          repo.to_json
        else
          error! repo.errors
        end
      rescue => e
        error! e.message
      end
    end

    params do
      requires :id, type: Integer, desc: ''
    end
    delete '/repositories/:id' do
      begin
        repo = Repository.find_by_id(params[:id])
        if repo
          repo.destroy
        else
          error! repo.errors
        end
      rescue => e
        error! e.message
      end
    end

  end
end
