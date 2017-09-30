class GitlabAPI
  BASE_URL = 'http://gitlab.swissdrg.local/api/v4/'

  attr_reader :url
  def initialize(url:)
    @url = url.gsub('/', '%2F')
  end

  def repository_details
    request = "#{BASE_URL}projects/#{url}?statistics=true&private_token=#{ENV.fetch('PRIVATE_TOKEN')}"
    response = HTTParty.get(request, timeout: 5)
    (JSON.parse response.body)
  end

  def self.repositories
    # TODO Handle more than 100 repos (100 is max from gitlab api)
    request = "#{BASE_URL}projects?private_token=#{ENV.fetch('PRIVATE_TOKEN')}&per_page=100"
    response = HTTParty.get(request, timeout: 5)
    (JSON.parse response.body)
  end

  def self.available
    repos_db = Repository.all.map(&:url)
    repos_gitlab = repositories.map{ |repo| repo['path_with_namespace']}
    repos_gitlab - repos_db
  end
end
