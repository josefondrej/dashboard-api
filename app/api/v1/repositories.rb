module V1
  class Repositories < Grape::API
    prefix :api
    version 'v1', using: :path
    format :json

    params do
      requires :id, type: Integer, desc: ''
    end
    get 'repositories/' do
      if false
      end
    end

    class Repository
      attr_reader :id, :name, :description
      def initialize(id:, name:, description: '')
        @id = id
        @name = name
        @description = description
      end

      def to_json
        {
          id: id,
          name: name,
          description: description
        }
      end
    end

    params do
      requires :id, type: Integer, desc: ''
    end
    get 'repositories/:id' do
      repo = Repository.new(id: 1, name: "manual_printer")
      if repo
        repo.to_json
      else
        error!("No repository with id #{params[:id]} found.", 404)
      end
    end
  end
end
