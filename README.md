# 📚 Sistema de Calificación de Reseñas de Libros

Sistema robusto de gestión de reseñas de libros desarrollado siguiendo **Test-Driven Development (TDD)** con Ruby on Rails y RSpec.

## 🎯 Características Principales

- ✅ Calificación de libros mediante sistema de 1-5 estrellas
- ✅ Reseñas con contenido de texto (máximo 1000 caracteres)
- ✅ Cálculo automático de promedio de calificaciones con redondeo a una décima
- ✅ Sistema de usuarios con capacidad de baneo
- ✅ Exclusión automática de reseñas de usuarios baneados
- ✅ Marcador de "Reseñas Insuficientes" para libros con menos de 3 reseñas válidas
- ✅ Cobertura completa de tests con RSpec

## 🛠️ Tecnologías Utilizadas

- **Ruby** 3.2.4
- **Rails** 7.1.6
- **RSpec** para testing
- **FactoryBot** para generación de datos de prueba
- **PostgreSQL** como base de datos

## 📋 Requisitos del Sistema

### Validaciones Implementadas

#### Review (Reseña)
- Calificación obligatoria (1-5 estrellas)
- Contenido de texto limitado a 1000 caracteres
- Asociación obligatoria con Usuario y Libro

#### Book (Libro)
- Título obligatorio
- Autor obligatorio
- Eliminación en cascada de reseñas asociadas

#### User (Usuario)
- Email único y obligatorio
- Campo `banned` con valores booleanos estrictos
- Eliminación en cascada de reseñas asociadas

### Lógica de Negocio

#### Cálculo de Promedio
```ruby
# Promedio redondeado a una décima
book.rating_average # => 4.3

# Mínimo 3 reseñas válidas requeridas
book.rating_average # => "Reseñas Insuficientes"
```

#### Exclusión de Usuarios Baneados
- Las reseñas de usuarios baneados **no** cuentan para:
  - El promedio de calificación
  - El conteo mínimo de 3 reseñas

## 🚀 Instalación

### 1. Clonar el repositorio
```bash
git clone https://github.com/tu-usuario/fair_book_ratings.git
cd book_review_system
```

### 2. Instalar dependencias
```bash
bundle install
```

### 3. Configurar la base de datos
```bash
rails db:create
rails db:migrate
```

### 4. Ejecutar los tests
```bash
bundle exec rspec
```

## 🚀 Instalación

### 1. Clonar el repositorio
```bash
git clone https://github.com/tu-usuario/book-review-system.git
cd book-review-system
```

### 2. Instalar dependencias
```bash
bundle install
```

### 3. Configurar la base de datos
```bash
rails db:create
rails db:migrate
```

### 4. Ejecutar los tests
```bash
bundle exec rspec
```

## 📁 Estructura del Proyecto

```
app/
├── models/
│   ├── book.rb          # Modelo de Libro
│   ├── review.rb        # Modelo de Reseña
│   └── user.rb          # Modelo de Usuario
spec/
├── factories/
│   ├── books.rb         # Factory de Libros
│   ├── reviews.rb       # Factory de Reseñas
│   └── users.rb         # Factory de Usuarios
├── models/
│   ├── book_spec.rb     # Tests de Libro
│   ├── review_spec.rb   # Tests de Reseña
│   └── user_spec.rb     # Tests de Usuario
└── support/
    └── factory_bot.rb   # Configuración de FactoryBot
```

## 🧪 Ejecución de Tests

### Ejecutar toda la suite
```bash
bundle exec rspec
```

### Ejecutar tests por modelo
```bash
bundle exec rspec spec/models/book_spec.rb
bundle exec rspec spec/models/review_spec.rb
bundle exec rspec spec/models/user_spec.rb
```
## 💡 Ejemplos de Uso

### Crear un libro
```ruby
book = Book.create!(title: "Cien Años de Soledad", author: "Gabriel García Márquez")
```

### Crear un usuario
```ruby
user = User.create!(email: "usuario@example.com", banned: false)
```

### Crear una reseña
```ruby
review = Review.create!(
  book: book,
  user: user,
  rating: 5,
  content: "Una obra maestra de la literatura latinoamericana"
)
```

### Calcular promedio de calificaciones
```ruby
book.rating_average  # => 4.7 o "Reseñas Insuficientes"
```

### Banear un usuario
```ruby
user.update(banned: true)
book.rating_average  # Automáticamente excluye sus reseñas
```

## 📝 Convenciones de Código

- Uso de FactoryBot para generación de datos de prueba
- Nombres descriptivos en español para los tests
- Agrupación lógica con `describe` y `context`
- Uso de `let` para definir variables compartidas
- Tests atómicos y específicos

## 👥 Autor

- **Cristian Rojas** - *Desarrollo del Proyecto* - [cristianrojasalexan](https://github.com/cristianrojasalexan)
