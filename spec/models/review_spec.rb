require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validaciones' do
    it 'es válido con atributos correctos' do
      review = build(:review, content: :content, rating: 4)
      expect(review).to be_valid
    end

    it 'es válido con calificaciones entre 1 y 5' do
      expect(build(:review, rating: 0)).not_to be_valid
      expect(build(:review, rating: 6)).not_to be_valid
      expect(build(:review, rating: 3)).to be_valid
    end

    it 'no es válido sin calificación' do
      review = build(:review, rating: nil)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("can't be blank")
    end

    it 'no es válido con limite de contenido mayor a 1000 caracteres' do
      review = build(:review, :long_content)
      expect(review).not_to be_valid
      expect(review.errors[:content]).to be_present
    end

    it 'es válido con una reseña exactamente con 1000 caracteres' do
      text = "a" * 1000
      review = build(:review, content: text)
      expect(review).to be_valid
    end

    it 'es válido con contenido nil' do
      review = build(:review, content: nil)
      expect(review).to be_valid
    end

    it 'no es válido usuario nil' do
      review = build(:review, user: nil)
      expect(review).not_to be_valid
      expect(review.errors[:user]).to be_present
    end

    it 'no es válido libro nil' do
      review = build(:review, book: nil)
      expect(review).not_to be_valid
      expect(review.errors[:book]).to be_present
    end
  end

  describe '#from_banned_user?' do
    it 'retorna true si el usuario está baneado' do
      review = create(:review, :from_banned_user)
      expect(review.from_banned_user?).to be true
    end

    it 'retorna false si el usuario no está baneado' do
      review = create(:review)
      expect(review.from_banned_user?).to be false
    end
  end
end
