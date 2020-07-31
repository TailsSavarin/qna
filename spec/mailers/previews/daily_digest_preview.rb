class DailyDigestPreview < ActionMailer::Preview
  def digest
    DailyDigestMailer.digest(User.first)
  end
end
