class GitlabAPI
  BASE_URL = 'http://gitlab.swissdrg.local/api/v4/'

  attr_reader :url
  def initialize(url:)
    @url = url.gsub('/', '%2F')
  end

  def repository_details
    request = GitlabAPI.build_query("projects/#{url}", 'statistics=true')
    response = HTTParty.get(request, timeout: 5)
    (JSON.parse response.body)
  end

  def self.repositories
    # TODO Handle more than 100 repos (100 is max from gitlab api)
    request = build_query('projects', 'per_page=100')
    response = HTTParty.get(request, timeout: 5)
    (JSON.parse response.body)
  end

  def self.available
    repos_db = Repository.all.map(&:url)
    repos_gitlab = repositories.map{ |repo| repo['path_with_namespace']}
    (repos_gitlab - repos_db).sort_by{ |r| r.downcase}
  end

  private

  def self.build_query(query, params='')
    "#{BASE_URL}#{query}?#{params}&private_token=#{ENV.fetch('PRIVATE_TOKEN')}"
  end
end
