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
        url: url,
        status: status_json
    }
  end

  def status_json
    response = HTTParty.get(url)
    {
      responseTime: status.response_time,
      code: response.code,
      response_time: response.headers["x-runtime"]
    }
  end
end
