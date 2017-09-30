class Server < ApplicationRecord
  has_many :deployments, dependent: :destroy
  has_many :repositories, through: :deployments

  def to_json
    {
      url: url,
      name: name
    }
  end
end
