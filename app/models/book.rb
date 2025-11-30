class Book < ApplicationRecord
    has_many :reviews, dependent: :destroy

    has_many :valid_reviews, -> {
        joins(:user).where(users: { banned: false })
    }, class_name: "Review"

    validates :title, :author, presence: true

    def rating_average
        return "Reseñas Insuficientes" if reviews.count < 3

        avg = valid_reviews_for_average.average(:rating)
        avg ? avg.round(1).to_f : "Reseñas Insuficientes"
    end

    def status
        valid_reviews.count < 3 ? "Insufficient Reviews" : "OK"
    end

    private

    def valid_reviews_for_average
        reviews.joins(:user).where(users: { banned: false })
    end
end
