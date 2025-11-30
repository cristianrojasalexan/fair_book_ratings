require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "validations" do
    it "requiere una calificación" do
      review = Review.new(rating: nil)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("can't be blank")
    end

    it "requiere una calificación entre 1 y 5" do
      user = User.create!(email: "test@gmail.com", banned: false)
      book = Book.create!(title: "Libro X", author: "Autor X")

      expect(Review.new(rating: 0, user: user, book: book)).not_to be_valid
      expect(Review.new(rating: 6, user: user, book: book)).not_to be_valid
      expect(Review.new(rating: 3, user: user, book: book)).to be_valid
    end

    it "limita el contenido a 1000 caracteres" do
      long_text = "a" * 1001
      review = Review.new(rating: 3, content: long_text)
      expect(review).not_to be_valid
      expect(review.errors[:content]).to include("is too long (maximum is 1000 characters)")
    end
  end

  describe "banned users" do

    it "marca reseñas de usuarios baneados como excluidas del promedio" do
      banned_user = User.create!(banned: true, email: "test@gmail.com")
      book = Book.create!(title: "Libro X", author: "Author X")

      review = Review.new(rating: 5, user: banned_user, book: book)

      expect(review.counts_for_average?).to eq(false)
    end
  end
end
