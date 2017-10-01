class GitlabAPI
  BASE_URL = 'http://gitlab.swissdrg.local/api/v4/'

  attr_reader :url
  def initialize(url:)
    @url = url.gsub('/', '%2F')
  end

  def repository_details
    JSON.parse GitlabAPI.get("projects/#{url}", 'statistics=true').body
  end

  def count_merge_requests
    GitlabAPI.get("projects/#{url}/merge_requests", 'per_page=1').headers['x-total']
  end

  def count_open_merge_requests
    GitlabAPI.get("projects/#{url}/merge_requests", 'state=opened&per_page=1').headers['x-total']
  end

  def self.repositories
    # TODO Handle more than 100 repos (100 is max from gitlab api)
    JSON.parse get('projects', 'per_page=100').body
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

  def self.get(query, params='')
    request = build_query(query, params)
    HTTParty.get(request, timeout: 5)
  end
end
