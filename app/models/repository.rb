class Repository < ApplicationRecord
  BASE_URL = ''.freeze

  before_save :load_data

  def to_json
    {
      id: id,
      name: name,
      description: description,
      url: url
    }
  end

  private

  def load_data
    self.name = url.split('/').last
    self.description = ""
  end

end
