class User < ApplicationRecord
    has_many :reviews, dependent: :destroy

    validates :email, presence: true, uniqueness: true
    validates :banned, inclusion: { in: [true, false] }

    def banned?
        banned
    end
end
