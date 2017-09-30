class Repository < ApplicationRecord
  has_many :servers, through: :deployments
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
      @url = url.gsub('/', '%2F')
    end

    def description
      request = "#{BASE_URL}projects/#{url}?statistics=true&private_token=mGiPmcWuNsBrA5q8awUz"
      response = HTTParty.get(request, timeout: 5)
      (JSON.parse response.body)['description']
    end

    def self.repositories
      request = "#{BASE_URL}projects?private_token=#{ENV.fetch('PRIVATE_TOKEN')}"
      response = HTTParty.get(request, timeout: 5)
      (JSON.parse response.body)
    end
  end

  private

  def load_data
    self.description = GitlabAPI.new(url: url).description
  end

end
