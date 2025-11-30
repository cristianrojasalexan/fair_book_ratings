require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "validations" do
    it "requiere una calificación" do
      review = Review.new(rating: nil)
      expect(review).not_to be_valid
    end

    it "requiere una calificación entre 1 y 5" do
      expect(Review.new(rating: 0)).not_to be_valid
      expect(Review.new(rating: 6)).not_to be_valid
      expect(Review.new(rating: 3)).to be_valid
    end

    it "limita el contenido a 1000 caracteres" do
      long_text = "a" * 1001
      review = Review.new(rating: 3, content: long_text)
      expect(review).not_to be_valid
    end
  end

  describe "banned users" do
    let(:banned_user) { User.new(banned: true) }

    it "marca reseñas de usuarios baneados como excluidas del promedio" do
      review = Review.new(rating: 5, user: banned_user)
      expect(review.counts_for_average?).to eq(false)
    end
  end
end
