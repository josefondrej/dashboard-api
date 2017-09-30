class Server < ApplicationRecord
  has_many :repositories, through: :deployments
end
