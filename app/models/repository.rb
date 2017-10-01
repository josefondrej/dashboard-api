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
                      mergeRequestsCount: gitlab.count_merge_requests,
                      openMergeRequestsCount: gitlab.count_open_merge_requests
                  })
  end

  def status_json
    status = if production_deployment
               server = production_deployment.server
               if server.up?
                 PingStatus.new(
                     response_time: server.ping,
                     message: 'OK',
                 )
               else
                 PingStatus.new(
                     response_time: server.ping,
                     message: 'FAIL',
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
    deployments.find(&:production?)
  end


  def assign_deployments
    deployments_params.each do |deployments_param|
      raise "Url empty for deployment #{deployments_param['kind']}" if deployments_param['url'].blank?
      begin
        server_ip = IPSocket::getaddress deployments_param['url'].gsub(/http(s){0,1}:\/\//, '')
      rescue
        raise "Url '#{deployments_param['url']}' could not be found."
      end
      server = Server.find_or_create_by(ip: server_ip) do |s|
        s.name = "#{name} (#{deployments_param['kind']})"
      end
      raise "Server with IP #{server_ip} not found." unless server
      self.servers << server
      deployment = deployments.find_by_server_id(server.id)
      deployment.kind = deployments_param['kind']
      deployment.url = deployments_param['url']
      deployment.save
    end
  end

  def load_data
    self.description = GitlabAPI.new(url: url).repository_details['description']
    self.name = GitlabAPI.new(url: url).repository_details['name']
  end
end
