module V1
  class Repositories < Grape::API
    prefix :api
    version 'v1', using: :path
    format :json

    get 'repositories/' do
      Repository.all.map(&:to_json)
    end

    get 'available_repositories/' do
      begin
        Repository::GitlabAPI.available
      rescue => e
        error! e.message
      end
    end

    params do
      requires :id, type: Integer, desc: ''
    end
    get 'repositories/:id' do
      begin
        repo = Repository.find_by_id(params[:id])
        if repo
          repo.to_json_extended
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
      requires :repository, type: Hash do
        requires :url, type: String, desc: 'Gitlab url of repository'
        optional :deployments, type: Array, desc: 'List of Apps on deployed server' do
          optional :kind, type: String, desc: 'Either production or stagging'
          optional :url, type: String, desc: 'Url of deployment'
        end
      end
    end
    post '/repositories' do
      begin
        repo = Repository.new(
          url: params[:repository][:url],
          deployments_params: params[:repository][:deployments]
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
