module ApiHelpers
  # rubocop:disable Lint/UselessAssignment
  def json
    json = JSON.parse(response.body)
  end
  # rubocop:enable Lint/UselessAssignment

  def do_request(method, path, options = {})
    send method, path, options
  end
end
