class Repository < ApplicationRecord
  before_save :load_data

  def to_json
    {
      id: id,
      name: name,
      description: description,
      url: url
    }
  end

  class GitlabAPI
    BASE_URL = 'http://gitlab.swissdrg.local/api/v4/'

    attr_reader :url
    def initialize(url:)
      @url = url
    end

    def description
      request = "#{BASE_URL}projects/#{url}?statistics=true&private_token=#{ENV['PRIVATE_TOKEN']}"
      response = HTTParty.get(request, timeout: 5)
      response.body['description']
    end

    def self.repositories
      request = "#{BASE_URL}projects?private_token=#{ENV['PRIVATE_TOKEN']}"
      response = HTTParty.get(request, timeout: 5)
      response.body
    end
  end

  private

  def load_data
    self.description = GitlabAPI.new(url: url).description
  end

end
