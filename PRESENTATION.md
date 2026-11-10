# Чистая архитектура на практике: проект BDUI Challenges


# О проекте 

**BDUI Challenges** — Flutter-приложение для отслеживания ежедневных челленджей («пробежать 2 км», «выпить 2 литра воды» и т.д.).

**Особенность:** интерфейс управляется с бэкенда. Сервер присылает JSON-схему экрана, клиент только рисует её через `BDUIEngine`.

**Четыре пакета (монOREPO на Dart):**
- `shared` — общие модели, сущности, исключения
- `server` — основной бэкенд (Shelf, порт 8080), бизнес-логика и генерация BDUI-экрана
- `template_server` — сервер шаблонов (порт 8082), подставляет данные в JSON-шаблоны
- `client` — Flutter-приложение, рендерит JSON-схему

---

# Архитектура проекта ДО изменений

**Что было сделано правильно (соответствует книге):**
- Слои `data` / `domain` / `presentation` в каждом пакете
- Интерфейсы репозиториев в `domain`, реализации в `data` (`ChallengeRepository`, `TemplateRepository`, `ChallengesGateway`)
- Use Cases (`TrackProgressUseCase`, `GetChallengesUseCase`) зависят от абстракций
- `Challenge` — доменная сущность с бизнес-правилами (`progressPercentage`, `updateProgress`)
- `BDUIEngine` на клиенте — Humble Object: сложно тестировать, поэтому он только рендерит

**Пример зависимостей ДО:**
```
Controller → ChallengeRepository (интерфейс) ← ShelfChallengeRepository (данные)
```

---

# Где проект нарушал книгу 

**Нарушение 1 — домен знает о данные.**  
`shared/lib/domain/models/challenge.dart` содержал `ChallengeMapper`, который импортировал `data/models/challenge_model.dart`. Домен зависел от внешнего слоя — это прямое нарушение правила зависимостей.

**Нарушение 2 — контроллер делает работу Use Case.**  
`BDUIController` сам брал челленджы из репозитория, считал статистику (`averageProgress`, `completedChallenges`) и собирал данные шаблона. Это бизнес-логика, которая должна жить в Use Case, а не в Interface Adapters.

**Нарушение 3 — DTO просачиваются в домен клиента.**  
Интерфейс `ChallengesGateway` принимал и возвращал `ChallengeModel` и `ProgressRequestModel` — типы для сетевого обмена, а не для бизнес-логики.

---

# Исправление 1. Mapper уходит из домена

**До (нарушение):**

```dart
// shared/lib/domain/models/challenge.dart — СЛОЙ: domain
import 'package:shared/data/models/challenge_model.dart'; // domain знает о data!

class ChallengeMapper {           // mapper жил в домене
  static Challenge toEntity(ChallengeModel model) { ... }
  static ChallengeModel toModel(Challenge entity) { ... }
}
```

**После (исправлено):**

```dart
// shared/lib/domain/models/challenge.dart — СЛОЙ: domain
class Challenge {
  double get progressPercentage => ...;
  bool get isInProgress => ...;
  bool isOverdue(DateTime now) => ...; // время передаётся снаружи
  Challenge updateProgress(double p) => ...;
}
```

```dart
// shared/lib/data/mappers/challenge_mapper.dart — СЛОЙ: data
import 'package:shared/data/models/challenge_model.dart';
import 'package:shared/domain/models/challenge.dart';

class ChallengeMapper {
  static Challenge toEntity(ChallengeModel model) { ... }
  static ChallengeModel toModel(Challenge entity) { ... }
}
```

**Что изменилось:** домен больше не импортирует `data`. Правило зависимостей восстановлено.

---

# Исправление 2. Тонкий контроллер и Use Case

**До:** `BDUIController` брал данные из репозитория и сам считал статистику.

```dart
// ДО
final challenges = await challengeRepository.getChallenges();
final totalProgress = challenges.fold(0.0, (sum, c) => sum + c.progressPercentage);
// ... сбор templateData напрямую в контроллере
```

**После:** статистика считается в `GetHomeScreenSummaryUseCase`, контроллер только вызывает его и отдаёт шаблону.

```dart
// ПОСЛЕ — Use Case (domain)
class GetHomeScreenSummaryUseCase {
  final ChallengeRepository repository;
  Future<HomeScreenSummary> execute() async {
    final challenges = await repository.getChallenges();
    return HomeScreenSummary(
      challenges: challenges,
      completedCount: ...,
      inProgressCount: ...,
      averageProgressPercent: ...,
    );
  }
}
```

```dart
// ПОСЛЕ — Контроллер (presentation), тонкий
final summary = await getHomeScreenSummaryUseCase.execute();
final ui = await renderTemplateUseCase.execute('home_screen', {
  'challenges': summary.challenges.map(cardPresenter.present).toList(),
  ...
});
```

**Почему это важно по книге:** Use Cases — это слой бизнес-правил приложения. Контроллер (Interface Adapters) не должен знать, как считается средний прогресс.

---

# Исправление 3. Типизированные ошибки вместо «ловим всё»

**До:** любая ошибка превращалась в 404 или 500, и отказ соединения с template server маскировался под «Challenge not found».

```dart
// ДО
catch (e, s) {
  print(e); print(s);
  return JsonUtils.jsonError('Challenge not found: $e', statusCode: 404);
}
```

**После:** доменные исключения, и контроллер маппит их в корректные HTTP-коды.

```dart
// shared/lib/domain/exceptions/challenge_not_found_exception.dart
class ChallengeNotFoundException implements Exception {
  final String challengeId;
  ChallengeNotFoundException(this.challengeId);
}

// server/lib/domain/exceptions/template_unavailable_exception.dart
class TemplateUnavailableException implements Exception {
  final String reason;
}
```

```dart
// В контроллере
on ChallengeNotFoundException catch (e) {
  return JsonUtils.jsonError(e.toString(), statusCode: 404);
}
on TemplateUnavailableException catch (e) {
  return JsonUtils.jsonError(e.toString(), statusCode: 502);
}
```

---

# Исправление 4. DTO убран из доменного шлюза клиента

**До:** `ChallengesGateway` (интерфейс домена) работал с `ChallengeModel` и `ProgressRequestModel`.

```dart
Future<List<ChallengeModel>> getChallenges();
Future<void> trackProgress({required ProgressRequestModel progress, required String id});
```

**После:** домен работает с сущностями, маппинг DTO ↔ сущность остаётся в `data`.

```dart
// Интерфейс (domain)
Future<List<Challenge>> getChallenges();
Future<void> trackProgress({required double progress, required String id});

// Реализация (data)
Future<List<Challenge>> getChallenges() async {
  final models = await api.getChallenges();
  return models.map(ChallengeMapper.toEntity).toList();
}
```
---

# Что осталось и спорные моменты 

**Сильная сторона проекта по книге:**  
`BDUIEngine` — классический Humble Object. Сложная часть (HTTP, Flutter, рендеринг) тонкая, а вся логика — в тестируемых Use Cases и сущностях.

**Что ещё можно улучшить (осталось в бэклоге):**
1. **Screaming Architecture.** Папки названы слоями (`data`, `domain`, `presentation`), а не возможностями (`challenges`, `templates`). Книга советует Struktur, которая кричит о domaine.
2. **Хранение.** Данные всё ещё в JSON-файле. Для продакшена нужна БД (Drift/SQLite), но за счёт Clean Architecture замена будет локальной.
3. **Версионирование схемы BDUI.** Клиент не проверяет версию JSON-схемы — при изменении на сервере клиент может сломаться.

---

# Выводы

**Что подтвердилось из книги:**
- Разделение на слои и инверсия зависимостей работают — мы поменяли способ хранения (JSON-файл) и генерацию UI (генераторы → шаблоны), не трогая Use Cases.
- Humble Object оправдан на клиенте: `BDUIEngine` тонкий и не содержит бизнес-логики.
- Доменные сущности с правилами (`updateProgress`, `progressPercentage`) делают код предсказуемым.

**Что пришлось исправить:**
- Домен не должен импортировать слои данных (правило зависимостей).
- Контроллеры должны быть тонкими; логика — в Use Cases.
- Ошибки должны быть типизированными, а не общим `catch (e)`.
- Тесты должны проверять поведение, а не только наличие роута.

**Главная мысль:** чистая архитектура — это не идеальная структура папок, а направление зависимостей. В проекте мы сделали dependencies идти к домену, и теперь код тестируем и поддерживаем.
