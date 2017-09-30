class Deployment < ApplicationRecord
  belongs_to :server
  belongs_to :repository

  PRODUCTION = 'production'.freeze

  def production?
    kind == PRODUCTION
  end

  def to_json
    {
        type: kind,
        url: server.url,
        status: repository.status_json
    }
  end
end
