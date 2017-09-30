class Deployment < ApplicationRecord
  belongs_to :server
  belongs_to :repository

  PRODUCTION = 'production'.freeze

  def production?
    kind == PRODUCTION
  end
end
