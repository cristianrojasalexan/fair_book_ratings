class User < ApplicationRecord
    has_many :reviews, dependent: :destroy

    validates :email, presence: true, uniqueness: true
end
