class NewAnswerNoticeJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNoticeService.send_notice(answer)
  end
end
