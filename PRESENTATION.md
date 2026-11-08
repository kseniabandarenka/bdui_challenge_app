# Чистая архитектура на практике: проект BDUI Challenges

Презентация для защиты после чтения книги «Чистая архитектура» (Robert C. Martin).
Формат: 25–30 минут, русский язык.

---

# Слайд 1. Титул
**Заголовок:** Чистая архитектура на практике: проект BDUI Challenges  
**Докладчик:** Ксения Бондаренко  
**Источник:** книга «Чистая архитектура», Роберт Мартин  
**Проект:** бэкенд-управляемый интерфейс (BDUI) для трекера ежедневных челленджей  

---

# Слайд 2. О чём книга (1–2 мин)

**Заголовок:** «Чистая архитектура» — главное

Книга описывает, как отделить бизнес-правила от деталей реализации, чтобы система была:
- **тестируемой** — без UI, базы данных и веб-фреймворка;
- **независимой от фреймворков** — Shelf/Dio/Flutter — это детали;
- **независимой от UI** — можно поменять интерфейс, не трогая бизнес-логику;
- **независимой от базы данных** — можно заменить JSON-файл на SQL.

**Главное правило:** зависимости направляются **внутрь**, к домену.  
Внешние слои (контроллеры, репозитории, презентеры) знают о домене, но домен не знает ни о ком.

---

# Слайд 3. Главные идеи книги (3 мин)

| Идея | Что означает |
|------|--------------|
| **Правило зависимостей** | Inner circles (Entities, Use Cases) не зависят от outer circles (Controllers, Gateways, DB) |
| **Entities** | Объекты с бизнес-правилами, не знающие о мире снаружи |
| **Use Cases** | Координируют поток данных для одного сценария, вызывают Entities и репозитории |
| **Границы** | Пересекаются через интерфейсы и простые данные (DTO/сущности), не через фреймворк-типы |
| **Humble Object** | Слой, который сложно тестировать (UI, HTTP), делают максимально тонким; вся логика уходит в тестируемый слой |
| **Компоненты / Screaming Architecture** | Структура папок должна кричать о возможностях системы, а не о фреймворках |

---

# Слайд 4. О проекте (2 мин)

**BDUI Challenges** — Flutter-приложение для отслеживания ежедневных челленджей («пробежать 2 км», «выпить 2 литра воды» и т.д.).

**Особенность:** интерфейс управляется с бэкенда. Сервер присылает JSON-схему экрана, клиент только рисует её через `BDUIEngine`.

**Четыре пакета (монOREPO на Dart):**
- `shared` — общие модели, сущности, исключения
- `server` — основной бэкенд (Shelf, порт 8080), бизнес-логика и генерация BDUI-экрана
- `template_server` — сервер шаблонов (порт 8082), подставляет данные в JSON-шаблоны
- `client` — Flutter-приложение, рендерит JSON-схему

---

# Слайд 5. Архитектура проекта ДО изменений (2 мин)

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

# Слайд 6. Где проект нарушал книгу (3 мин)

**Нарушение 1 — домен знает о данные.**  
`shared/lib/domain/models/challenge.dart` содержал `ChallengeMapper`, который импортировал `data/models/challenge_model.dart`. Домен зависел от внешнего слоя — это прямое нарушение правила зависимостей.

**Нарушение 2 — контроллер делает работу Use Case.**  
`BDUIController` сам брал челленджы из репозитория, считал статистику (`averageProgress`, `completedChallenges`) и собирал данные шаблона. Это бизнес-логика, которая должна жить в Use Case, а не в Interface Adapters.

**Нарушение 3 — DTO просачиваются в домен клиента.**  
Интерфейс `ChallengesGateway` принимал и возвращал `ChallengeModel` и `ProgressRequestModel` — типы для сетевого обмена, а не для бизнес-логики.

**Нарушение 4 — мёртвый код.**  
Три неиспользуемых Use Case (`GetChallengesUseCase`, `GetTodaysChallenges`, `GetHomeScreenDataUseCase`) и два генератора экранов, которые дублировали логику контроллера.

---

# Слайд 7. Исправление 1. Mapper уходит из домена (3 мин)

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

# Слайд 8. Исправление 2. Тонкий контроллер и Use Case (4 мин)

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

# Слайд 9. Исправление 3. Типизированные ошибки вместо «ловим всё» (3 мин)

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

**Тест:** теперь недоступный template server даёт 502, а не 404 — это проверяется в `server/test/router_test.dart`.

---

# Слайд 10. Исправление 4. DTO убран из доменного шлюза клиента (2 мин)

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

**Тест:** `client/test/challenges_gateway_test.dart` проверяет, что в домен уходят сущности `Challenge`, а не `ChallengeModel`.

---

# Слайд 11. Исправление 5. Тесты проверяют содержимое, а не просто «не 404» (3 мин)

**До:** тесты проверяли только `isNot(equals(404))`, при этом `GET /api/challenges` падал с 500, а тест оставался зелёным.

**После:** 21 тест на сервере проверяет тела ответов, коды 200/400/404/502 и состояние репозитория после запроса.

```dart
test('POST /api/challenges/<id>/progress обновляет прогресс', () async {
  final response = await _send(handler, 'POST', '/api/challenges/3/progress',
      body: {'progress': 4});
  expect(response.statusCode, 200);
  final body = await _json(response);
  expect(body['success'], isTrue);
  expect(body['data']['completed'], isTrue);
});
```

**Итог по тестам:**
| Пакет | Тестов ДО | Тестов ПОСЛЕ | Статус |
|-------|-----------|--------------|--------|
| shared | 3 | 12 | ✅ |
| server | 3 | 21 | ✅ |
| client | 1 (заглушка) | 2 | ✅ |
| template_server | 4 (плохие) | 6 | ✅ |

`dart analyze` — чистый во всех четырёх пакетах.

---

# Слайд 12. Что осталось и спорные моменты (2 мин)

**Сильная сторона проекта по книге:**  
`BDUIEngine` — классический Humble Object. Сложная часть (HTTP, Flutter, рендеринг) тонкая, а вся логика — в тестируемых Use Cases и сущностях.

**Что ещё можно улучшить (осталось в бэклоге):**
1. **Screaming Architecture.** Папки названы слоями (`data`, `domain`, `presentation`), а не возможностями (`challenges`, `templates`). Книга советует Struktur, которая кричит о domaine.
2. **Время в сущности.** `isOverdue(DateTime now)` — время передаётся снаружи, это хорошо, но можно вынести ещё больше побочных эффектов.
3. **Хранение.** Данные всё ещё в JSON-файле, без блокировки при параллельной записи. Для продакшена нужна БД (Drift/SQLite), но за счёт Clean Architecture замена будет локальной.
4. **Версионирование схемы BDUI.** Клиент не проверяет версию JSON-схемы — при изменении на сервере клиент может сломаться.

---

# Слайд 13. Выводы (2 мин)

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

---

# Заметки докладчика (тайминг, итого ~27 мин)

| Слайд | Время | Что сказать |
|-------|-------|-------------|
| 1 Титул | 1 мин | Представиться, название работы, источник (книга Мартина) |
| 2 О книге | 2 мин | Главная цель: отделение бизнеса от деталей (UI, БД, фреймворк) |
| 3 Идеи | 3 мин | Правило зависимостей, Entities, Use Cases, границы, Humble Object |
| 4 Проект | 2 мин | Что такое BDUI Challenges, 4 пакета, схема сервер → шаблон → клиент |
| 5 До | 2 мин | Что уже было хорошо: слои, интерфейсы, Humble Object на клиенте |
| 6 Проблемы | 3 мин | 4 нарушения: mapper в домене, логика в контроллере, DTO в шлюзе, мёртвый код |
| 7 Mapper | 3 мин | Показать код до/после, объяснить правило зависимостей |
| 8 Use Case | 4 мин | Показать, как статистика ушла из контроллера в `GetHomeScreenSummaryUseCase` |
| 9 Ошибки | 3 мин | Показать typed exceptions и разницу 404 vs 502 |
| 10 DTO | 2 мин | Домен работает с сущностями, маппинг в data |
| 11 Тесты | 3 мин | Показать таблицу тестов и пример проверки тела ответа |
| 12 Осталось | 2 мин | Сcreaming Architecture, версия схемы, БД вместо файла |
| 13 Выводы | 2 мин | Итог: зависимости к домену, код тестируем |

**Итого: ≈ 27 минут.**

---

## Как использовать файл

- Откройте `PRESENTATION.md` в любом редакторе Markdown — каждая часть между `---` — отдельный слайд.
- Текст под жирными заголовками «Заголовок» — содержимое слайда.
- Курсивные блоки `> ...` и таблицы — speaker notes.
- Код-блоки с маркерами `// ДО` и `// ПОСЛЕ` — примеры для живой демонстрации или вставки на слайд.
