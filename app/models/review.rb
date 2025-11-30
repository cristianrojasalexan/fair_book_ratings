class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :rating, presence: true, inclusion: { in: 1..5 }

  validates :content, length: { maximum: 1000 }

  def counts_for_average?
    return false if user&.banned?
    true
  end
end
