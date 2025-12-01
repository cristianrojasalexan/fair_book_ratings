class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  MAX_CONTENT_LENGTH = 1000

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :content, length: { maximum: MAX_CONTENT_LENGTH, message: 'máximo 1000 caracteres' }, allow_blank: true

  def from_banned_user?
    user&.banned? || false
  end
end
