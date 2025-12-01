class Book < ApplicationRecord
    has_many :reviews, dependent: :destroy

    validates :title, :author, presence: true

    MINIMUM_REVIEWS = 3

    def rating_average
        valid_reviews = valid_reviews_for_average

        return 'Reseñas Insuficientes' if valid_reviews.count < MINIMUM_REVIEWS

        avg = valid_reviews.average(:rating)
        avg ? avg.round(1).to_f : 'Reseñas Insuficientes'
    end

    def reviews_count
        valid_reviews_for_average.count
    end

    def add_review(review)
        reviews << review if review.valid?
    end

    private
    def valid_reviews_for_average
        reviews.joins(:user).where(users: { banned: false })
    end
end
