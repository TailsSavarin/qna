class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true,
                  format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  def gist?
    url.include?('gist.github.com')
  end

  def gist_parse
    url.split('/').last
  end
end
