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
    return {
      ping: -1,
      code: 500,
      responseTime: -1
    } unless url

    response = HTTParty.get(url)
    {
      ping: status.response_time,
      code: response.code,
      responseTime: response.headers["x-runtime"]
    }
  end
end
