require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:user) { User.create!(email: "test@test.com", banned: false) }

  describe "#rating_average" do
    it "retorna 'Reseñas Insuficientes' si hay menos de 3 reseñas válidas" do
      book = Book.create!(title: "Libro X")
      2.times { book.reviews.create!(rating: 4, user: user) }

      expect(book.rating_average).to eq("Reseñas Insuficientes")
    end

    it "calcula el promedio con una décima" do
      book = Book.create!(title: "Libro Y")
      book.reviews.create!(rating: 5, user: user)
      book.reviews.create!(rating: 4, user: user)
      book.reviews.create!(rating: 3, user: user)

      expect(book.rating_average).to eq(4.0) # (5+4+3)/3
    end

    it "excluye reseñas de usuarios baneados" do
      banned_user = User.create!(email: "bad@test.com", banned: true)

      book = Book.create!(title: "Libro Z")
      book.reviews.create!(rating: 5, user: user)
      book.reviews.create!(rating: 1, user: banned_user)
      book.reviews.create!(rating: 4, user: user)

      expect(book.rating_average).to eq(4.5)
    end
  end
end
