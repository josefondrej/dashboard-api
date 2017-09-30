class Server < ApplicationRecord
  has_many :deployments, dependent: :destroy
  has_many :repositories, through: :deployments

  def to_json
    {
      url: url,
      name: name
    }
  end

  def up?
    check = Net::Ping::External.new(url)
    check.ping?
  end
end
