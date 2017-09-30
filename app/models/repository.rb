class Repository < ApplicationRecord
  has_many :deployments
  has_many :servers, through: :deployments
  accepts_nested_attributes_for :deployments
  before_save :load_data
  after_save :assign_deployments

  attr_accessor :deployments_params

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

  def assign_deployments
    deployments_params.each do |deployments_param|
      server = Server.find_or_create_by(url: deployments_param['url'])
      self.servers << server
      deployment = Deployment.where(server_id: server.id, repository_id: id).first
      deployment.kind = deployments_param['kind']
      deployment.save
    end
  end

  def load_data
    self.description = GitlabAPI.new(url: url).description
  end

end
