class Repository < ApplicationRecord
  BASE_URL = ''.freeze

  before_save :load_data

  private

  def load_data
    self.name = url.split('/').last
    self.description = ""
  end

  def to_json
    {
      id: id,
      name: name,
      description: description,
      url: url
    }
  end
end
