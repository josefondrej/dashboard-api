module V1
  class Repositories < Grape::API
    prefix :api
    version 'v1', using: :path
    format :json

    get 'repositories/' do
      Repository.all
    end

    class Repository
      attr_reader :id, :name, :description, :url

      def initialize(id:,
                     name:,
                     description: '',
                     url: '')
        @id = id
        @name = name
        @description = description
        @url = url
      end

      def self.all
        [
          new(
            id: -1337,
            name: "4chan",
            description: "where the fun begins..",
            url: "www.4chan.org"
          )
        ]
      end

      def to_json
        {
          id: id,
          name: name,
          description: description,
          url: url
        }
      end

      def valid?
        true
      end

      def save
      end

      def errors
        []
      end
    end

    params do
      requires :id, type: Integer, desc: ''
    end
    get 'repositories/:id' do
      begin
        repo = Repository.new(id: 1, name: "manual_printer")
        if repo.valid?
          repo.to_json
        else
          error!("No repository with id #{params[:id]} found.", 404)
        end
      rescue => e
        error! e.message
      end
    end

    params do
      requires :url, type: String, desc: 'Url of target repository'
    end
    post '/repository' do
      begin
        repo = Repository.new(
          id: -1,
          name: "foo",
          description: "fooabr",
          url: params[:url]
        )

        if repo.valid?
          repo.save
        else
          error! repo.errors
        end
      rescue => e
        error! e.message
      end
    end

  end
end
