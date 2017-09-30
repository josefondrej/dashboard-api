class Server < ApplicationRecord
  has_many :deployments, dependent: :destroy
  has_many :repositories, through: :deployments

  def to_json
    {
      id: id,
      url: url,
      name: name,
      detailUrl: "servers/#{id}"
    }
  end

  def ping
    cmd = "ping -c 1 #{url} | tail -1 | awk '{print $4}' | cut -d '/' -f 2"
    ping_response = %x(cmd).strip
    return -1 if ping_response.include? "unknown host"
    ping_response.to_i
  end

  def up?
    check = Net::Ping::External.new(url)
    check.ping?
  end
end
