require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validaciones' do
    it 'es válido con atributos válidos' do
      user = build(:user)
      expect(user).to be_valid
    end

    context 'email' do
      it 'requiere un email' do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'requiere un email único' do
        create(:user, email: 'test@example.com')
        duplicate = build(:user, email: 'test@example.com')
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:email]).to include('has already been taken')
      end

      it 'permite emails diferentes' do
        create(:user, email: 'user1@example.com')
        user2 = build(:user, email: 'user2@example.com')
        expect(user2).to be_valid
      end
    end

    context 'banned' do
      it 'permite banned en true' do
        user = build(:user, banned: true)
        expect(user).to be_valid
      end

      it 'permite banned en false' do
        user = build(:user, banned: false)
        expect(user).to be_valid
      end

      it 'no permite banned en nil' do
        user = build(:user, banned: nil)
        expect(user).not_to be_valid
        expect(user.errors[:banned]).to be_present
      end

      it 'tiene banned en false por defecto' do
        user = create(:user, email: 'default@example.com')
        expect(user.banned).to be_falsey
      end

      it 'no permite banned en nil' do
        user = build(:user, banned: nil)
        expect(user).not_to be_valid
        expect(user.errors[:banned]).to include('is not included in the list')
      end
    end
  end

  describe 'asociaciones' do
    it 'tiene muchas reseñas' do
      association = User.reflect_on_association(:reviews)
      expect(association.macro).to eq(:has_many)
    end

    it 'puede tener varias reseñas asociadas' do
      user = create(:user)
      book = create(:book)
      book2 = create(:book)

      review1 = create(:review, user: user, book: book)
      review2 = create(:review, user: user, book: book2)

      expect(user.reviews).to include(review1, review2)
      expect(user.reviews.count).to eq(2)
    end

    it 'elimina sus reseñas al borrar al usuario (dependent: :destroy)' do
      user = create(:user)
      book = create(:book)
      review1 = create(:review, user: user, book: book)
      review2 = create(:review, user: user, book: book)
      
      review_ids = [review1.id, review2.id]
      expect { user.destroy }.to change(Review, :count).by(-2)
      review_ids.each do |review_id|
        expect(Review.exists?(review_id)).to be false
      end
    end
  end

  describe '#banned?' do
    it 'retorna true cuando el usuario está baneado' do
      user = build(:user, banned: true)
      expect(user.banned?).to be(true)
    end

    it 'el valor por defecto de banned es false' do
      user = create(:user)
      expect(user.banned?).to be false
    end

    it 'puede cambiar el estado de baneado' do
      user = create(:user, banned: false)
      expect(user.banned?).to be false
      
      user.update(banned: true)
      expect(user.banned?).to be true
    end
  end
end
