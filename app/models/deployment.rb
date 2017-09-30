class Deployment < ApplicationRecord
  belongs_to :server
  belongs_to :repository
end
