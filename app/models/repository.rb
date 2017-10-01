class Repository < ApplicationRecord
  has_many :deployments, dependent: :destroy
  has_many :servers, through: :deployments
  accepts_nested_attributes_for :deployments
  before_save :load_data
  after_save :assign_deployments

  attr_accessor :deployments_params

  def to_json
    {
      id: id,
      name: name,
      status: status_json,
      detailUrl: "repositories/#{id}",
      productionUrl: production_deployment&.url || ''
    }
  end

  def to_json_extended
    gitlab = GitlabAPI.new(url: url)
    to_json.merge({
        description: description,
        url: url,
        lastActivity: gitlab.repository_details['last_activity_at'],
        deployments: deployments.map(&:to_json),
        merge_requests_count: gitlab.count_merge_requests,
        open_merge_requests_count: gitlab.count_open_merge_requests
    })
  end

  def status_json
    status = if production_deployment
              server = production_deployment
              if server.up?
                PingStatus.new(
                    response_time: server.ping,
                    message: 'OK'
                )
              else
                PingStatus.new(
                    response_time: server.ping,
                    message: 'FAIL'
                )
              end
            else
              PingStatus.new(message: 'NO_PRODUCTION')
            end

    {
        responseTime: status.response_time,
        message: status.message
    }
  end

  private

  def production_deployment
    deployments.find(&:production?)&.server
  end


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
    self.description = GitlabAPI.new(url: url).repository_details['description']
    self.name = GitlabAPI.new(url: url).repository_details['name']
  end
end
