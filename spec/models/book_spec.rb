require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { create(:book) }
  let(:user) { create(:user) }
  let(:banned_user) { create(:user, :banned) }

  describe 'validaciones' do
    it 'es válido con atributos válidos' do
      book = build(:book)
      expect(book).to be_valid
    end

    context 'title' do
      it 'requiere título' do
        book = build(:book, title: nil)
        expect(book).not_to be_valid
        expect(book.errors[:title]).to include("can't be blank")
      end

      it 'permite títulos diferentes' do
        create(:book, title: 'Book 1')
        book2 = build(:book, title: 'Book 2')
        expect(book2).to be_valid
      end
    end

    context 'author' do
      it 'requiere autor' do
        book = build(:book, author: nil)
        expect(book).not_to be_valid
        expect(book.errors[:author]).to include("can't be blank")
      end

      it 'es válido con un autor' do
        book = build(:book, author: 'John Doe')
        expect(book).to be_valid
      end
    end
  end

  describe "asociaciones" do
    it 'tiene muchas reseñas' do
      association = Book.reflect_on_association(:reviews)
      expect(association.macro).to eq(:has_many)
    end

    it 'elimina sus reseñas al borrar el libro (dependent: :destroy)' do
      review1 = create(:review, book: book)
      review2 = create(:review, book: book)
      
      review_ids = [review1.id, review2.id]

      expect { book.destroy }.to change(Review, :count).by(-2)
      
      review_ids.each do |review_id|
        expect(Review.exists?(review_id)).to be false
      end
    end
  end

  describe '#add_review' do
    it 'agrega una reseña al libro' do
      review = build(:review, rating: 5, content: 'Excelente', book: book)
      book.add_review(review)
      expect(book.reviews.count).to eq(1)
    end

    it 'permite agregar múltiples reseñas' do
      review1 = build(:review, rating: 5, book: book)
      review2 = build(:review, rating: 4, book: book)
      book.add_review(review1)
      book.add_review(review2)
      expect(book.reviews.count).to eq(2)
    end
  end

  describe '#rating_average' do
    context 'con menos de 3 reseñas' do
      it 'retorna "Reseñas Insuficientes" con 0 reseñas' do
        expect(book.rating_average).to eq('Reseñas Insuficientes')
      end

      it 'retorna "Reseñas Insuficientes" con 2 reseñas' do
        create(:review, rating: 5, book: book, user: user)
        create(:review, rating: 4, book: book, user: user)
        expect(book.rating_average).to eq('Reseñas Insuficientes')
      end

      it 'retorna "Reseñas Insuficientes" cuando solo hay 2 reseñas válidas y 1 de usuario baneado' do
        create(:review, rating: 5, book: book, user: user)
        create(:review, rating: 4, book: book, user: user)
        create(:review, rating: 1, book: book, user: banned_user)
        expect(book.rating_average).to eq('Reseñas Insuficientes')
      end
    end

    context 'con 3 o más reseñas válidas' do
      it 'calcula el promedio con 3 reseñas' do
        create(:review, rating: 5, book: book, user: user)
        create(:review, rating: 4, book: book, user: user)
        create(:review, rating: 3, book: book, user: user)
        expect(book.rating_average).to eq(4.0)
      end

      it 'redondea a una décima' do
        create(:review, rating: 5, book: book, user: user)
        create(:review, rating: 4, book: book, user: user)
        create(:review, rating: 4, book: book, user: user)
        expect(book.rating_average).to eq(4.3)
      end

      it 'redondea correctamente hacia arriba' do
        create(:review, rating: 5, book: book, user: user)
        create(:review, rating: 5, book: book, user: user)
        create(:review, rating: 4, book: book, user: user)
        create(:review, rating: 4, book: book, user: user)
        expect(book.rating_average).to eq(4.5)
      end
    end

    context 'excluyendo reseñas de usuarios baneados' do
      it 'no cuenta reseñas de usuarios baneados en el promedio' do
        create(:review, rating: 5, book: book, user: user)
        create(:review, rating: 4, book: book, user: user)
        create(:review, rating: 3, book: book, user: user)
        create(:review, rating: 1, book: book, user: banned_user)
        expect(book.rating_average).to eq(4.0)
      end

      it 'no cuenta reseñas de usuarios baneados para el conteo mínimo' do
        create(:review, rating: 1, book: book, user: banned_user)
        create(:review, rating: 1, book: book, user: banned_user)
        create(:review, rating: 5, book: book, user: user)
        create(:review, rating: 4, book: book, user: user)
        expect(book.rating_average).to eq('Reseñas Insuficientes')
      end

      it 'marca reseñas de usuarios baneados como excluidas del promedio' do
        valid_reviews = create_list(:review, 3, book: book, user: user, rating: 5)
        banned_reviews = create_list(:review, 2, book: book, user: banned_user, rating: 1)
        
        # Verifica que las reseñas de usuarios baneados están marcadas
        banned_reviews.each do |review|
          expect(review.from_banned_user?).to be true
        end
        
        # Verifica que las reseñas válidas NO están marcadas
        valid_reviews.each do |review|
          expect(review.from_banned_user?).to be false
        end
        
        # Verifica que el promedio solo cuenta las reseñas válidas (3 x 5 = 15 / 3 = 5.0)
        # y NO las de usuarios baneados (que tenían rating 1)
        expect(book.rating_average).to eq(5.0)
      end
    end
  end

  describe '#reviews_count' do
    it 'retorna el número total de reseñas válidas' do
      create(:review, rating: 5, book: book, user: user)
      create(:review, rating: 4, book: book, user: user)
      create(:review, rating: 1, book: book, user: banned_user)
      expect(book.reviews_count).to eq(2)
    end
  end
end
