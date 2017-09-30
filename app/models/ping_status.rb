class PingStatus
  attr_reader :response_time, :message
  def initialize(response_time: -1, message:)
    @response_time = response_time
    @message = message
  end
end
