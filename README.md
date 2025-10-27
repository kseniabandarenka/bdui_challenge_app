#  BDUI Challenges - Backend Driven UI Flutter приложение

## О проекте

**BDUI Challenges** - это Flutter приложение, демонстрирующее подход **Backend Driven UI (BDUI)**, где:
- **Сервер полностью управляет интерфейсом** - определяет структуру, компоненты и данные
- **Клиент рендерит UI на основе JSON схем** с сервера
- **Динамическое обновление** - изменение UI без обновления приложения

## Структура проекта

- **client/** - Flutter клиент
  - lib/bdui/ - Кастомный UI фреймворк
  - lib/custom/ - Кастомные компоненты
  - lib/navigation/ - Навигация
  - lib/screen/ - Экраны приложения

- **server/** - Dart сервер
  - lib/presentation/ - Контроллеры API
  - lib/domain/ - Бизнес-логика
  - lib/data/ - Доступ к данным
  - lib/infrastructure/ - Инфраструктура

- **shared/** - Общие ресурсы
  - lib/data/models/ - Модели данных
  - lib/domain/ - Общая бизнес-логика


## Запуск проекта

### Установка зависимостей

```bash
# Общие зависимости
cd shared  
dart pub get 

# Сервер
cd server 
dart pub get 

# Клиент
cd client 
flutter pub get

### Генерация кода (для shared пакета)
```bash
cd shared
flutter pub run build_runner build


## Запуск приложения

### Запуск сервера:

cd server
dart run bin/server.dart

### Запуск клиента:

cd client
flutter run