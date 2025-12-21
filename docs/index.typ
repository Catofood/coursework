#import "lib/gost.typ": *
#import "lib/titlepage.typ": *

#titlepage(
  title: "АНАЛИТИЧЕСКИЙ МИКРОСЕРВИС ДЛЯ БОТА С РАСПИСАНИЕМ ГУАП",
  authors: ("И.К. Крылов",),
  teachers: ("А.А. Фоменкова",),
  date: datetime.today(),
  education: "МИНИСТЕРСТВО НАУКИ И ВЫСШЕГО ОБРАЗОВАНИЯ РОССИЙСКОЙ ФЕДЕРАЦИИ
федеральное государственное автономное образовательное учреждение высшего образования
 «САНКТ-ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ 
АЭРОКОСМИЧЕСКОГО ПРИБОРОСТРОЕНИЯ»",
  department: "КАФЕДРА КОМПЬЮТЕРНЫХ ТЕХНОЛОГИЙ И ПРОГРАММНОЙ ИНЖЕНЕРИИ",
  position: "Доцент, к.т.н",
  documentName: "ПОЯСНИТЕЛЬНАЯ ЗАПИСКА
К КУРСОВОЙ РАБОТЕ (ПРОЕКТУ)",
  group: "М411",
  city: "Санкт-Петербург",
  object: "",
)


#show: doc => init(doc)

#ch("ВВЕДЕНИЕ")

Актуальность разработки аналитического микросервиса для Telegram-бота расписания ГУАП обусловлена растущей необходимостью отслеживания и анализа использования информационной системы. Миграция бота на облачную инфраструктуру и его интеграция с микросервисной архитектурой требует разработки специализированного сервиса для сбора, хранения и анализа метрик использования.

Целью работы является разработка микросервиса аналитики, который обеспечивает: сбор событий использования бота в реальном времени через Kafka; хранение структурированных данных о пользователях, запросах и событиях обновления; предоставление REST API для получения статистики использования бота; интеграцию с основным сервисом SuaiScheduleBot через асинхронную очередь сообщений.

Задачи работы: анализ предметной области и выявление требований; проектирование архитектуры микросервиса с использованием принципов Clean Architecture; реализация слоев Domain, Application, Infrastructure и API; разработка компонентов для потребления событий из Kafka; создание репозиториев и запросов к базе данных PostgreSQL; разработка и тестирование API endpoints для получения аналитики; документирование кода и написание пояснительной записки.
#pagebreak()

= Анализ предметной области

== Первичная постановка задачи

Разрабатываемый микросервис SuaiScheduleBotAnalytics предназначен для сбора, обработки и предоставления статистики использования Telegram-бота расписания ГУАП. Основной сервис SuaiScheduleBot при выполнении пользовательских действий (просмотр расписания, подписка на группу и т.д.) отправляет сообщения в очередь Kafka. Сервис аналитики должен потреблять эти события и сохранять их в базе данных для последующего анализа.

Требования к системе: сбор событий от основного бота в реальном времени; хранение информации о пользователях, группах, запросах и обновлениях; предоставление API для получения различных метрик и статистики; поддержка фильтрации данных по временным периодам; обеспечение надежности и масштабируемости системы; соответствие принципам Clean Architecture для обеспечения maintainability.

== Анализ предметной области

В контексте разработки данной системы ключевыми понятиями являются:

*Пользователь* — зарегистрированный пользователь Telegram, взаимодействующий с ботом расписания. Каждый пользователь идентифицируется уникальным Telegram ID и содержит информацию о дате регистрации, предпочитаемой группе и истории запросов.

*Группа* — академическая группа ГУАП (например, М411, М412 и т.д.). Пользователи могут просматривать расписание различных групп и подписываться на избранные группы.

*Запрос пользователя* — действие пользователя в боте, включающее просмотр расписания для конкретной группы. Каждый запрос содержит тип запроса, временную метку, ссылку на пользователя и группу.

*Событие обновления* — событие, возникающее при обновлении информации о пользователе (например, при подписке на новую группу). Хранит тип события, пользователя и группу.

*Метрика* — агрегированные данные о использовании системы, включая количество пользователей, популярные группы, пиковые часы использования.

Проблема, решаемая данным микросервисом: основной бот генерирует большое количество событий, которые требуют обработки, хранения и анализа. Централизованный микросервис аналитики позволяет отделить логику сбора метрик от основной логики бота, обеспечивая лучшую масштабируемость и производительность системы.

== Анализ возможных методов решения

=== Архитектурные подходы

При разработке микросервиса были рассмотрены следующие архитектурные подходы:

*Монолитная архитектура*: интеграция модуля аналитики непосредственно в основной бот. Преимущества: простота развертывания, прямой доступ к данным. Недостатки: увеличение связанности кода, сложность масштабирования, влияние на производительность основного сервиса.

*Микросервисная архитектура (выбранный вариант)*: отдельный независимый сервис для аналитики, взаимодействующий с основным ботом через асинхронную очередь Kafka. Преимущества: разделение ответственности, независимая масштабируемость, асинхронная обработка не влияет на основной сервис. Недостатки: повышенная сложность развертывания, необходимость управления распределенными транзакциями.

*Real-time streaming*: использование Apache Kafka Streams или Event Sourcing для обработки событий. Преимущества: высокая производительность, возможность обработки больших объемов данных. Недостатки: сложность разработки, требует специализированных знаний.

Выбранный вариант (микросервисная архитектура) обеспечивает оптимальный баланс между простотой разработки, масштабируемостью и отделением ответственности.

=== Технологические решения

*Фреймворк и язык*: ASP.NET Core 9 с языком C\# был выбран за счет встроенной поддержки внедрения зависимостей (DI), наличия удобных библиотек для работы с Kafka (MassTransit), хорошей производительности и экосистемы, удобства разработки и мощных инструментов.

*Управление данными*: Entity Framework Core (EF Core) с PostgreSQL обеспечивает объектно-реляционное отображение (ORM), миграции БД, поддержку сложных запросов и транзакционность.

*Потребление событий*: MassTransit + Kafka обеспечивает гибкую конфигурацию потребителей, автоматическое управление подписками, поддержку retry-логики и легкую интеграцию с DI контейнером.

*Паттерны проектирования*: Clean Architecture (без DDD) обеспечивает четкое разделение слоев, независимость от деталей реализации, облегчает тестирование и упрощает поддержку и расширение.

== Цели и задачи разработки программы

*Цель разработки*: создать масштабируемый микросервис для сбора и анализа метрик использования Telegram-бота расписания ГУАП, обеспечивающий асинхронную обработку событий без влияния на производительность основного сервиса.

*Основные задачи*:

Проектирование архитектуры микросервиса включает разделение логики на четыре слоя: Domain, Application, Infrastructure и WebApi, в соответствии с принципами Clean Architecture.

Определение доменных моделей (UserEntity, GroupEntity, RequestEntity, UpdateEntity) и их отношений в системе для правильного представления бизнес-сущностей.

Реализация потребителей Kafka (UserPerformedRequestConsumer, UserUpdatedMessageConsumer) для асинхронной обработки событий от основного бота без нарушения его производительности.

Разработка репозиториев и абстракций доступа к данным для операций создания, чтения и фильтрации данных из базы.

Создание REST API endpoints (StatisticsController) с использованием MediatR для обработки запросов статистики и предоставления метрик администраторам.

Обеспечение интеграции с PostgreSQL через Entity Framework Core с поддержкой миграций баз данных и оптимизацией LINQ запросов.

Реализация валидации входных данных и обработки ошибок на уровне Application слоя с выбросом типизированных исключений.

Разработка Docker Compose конфигурации для упрощения локальной разработки и production развертывания микросервиса.

Создание полной документации REST API через Swagger/OpenAPI с описанием всех endpoints, параметров и примеров ответов.

Проведение комплексного тестирования компонентов и интеграционных тестов для обеспечения качества реализации всех требований.

#pagebreak()

= Разработка требований к программе
== Требования к пользовательскому интерфейсу
=== Общая характеристика пользовательского интерфейса

Микросервис аналитики предоставляет REST API, взаимодействие с которым осуществляется через HTTP запросы. Пользователями API являются как администраторы для получения статистики, так и различные микросервисы экосистемы.

=== Сценарии использования

*Сценарий 1: Получение количества зарегистрированных пользователей*

Администратор отправляет GET запрос на `/api/statistics/registered-users-count` с параметрами `from` и `to` (опционально, в формате ISO 8601) для получения количества зарегистрировавшихся пользователей. Запрос возвращает целое число з исключением HTTP 400 при некорректном формате дат.

*Сценарий 2: Получение уникальных пользователей, просмотревших расписание*

Администратор запрашивает количество уникальных пользователей, просмотревших любое расписание. Параметры `from` и `to` опциональны. Ответ возвращается количество уникальных пользователей, или HTTP 400 если дата начала позже даты окончания.

*Сценарий 3: Получение уникальных пользователей по типу расписания*

Администратор получает количество уникальных пользователей для конкретного типа расписания (аудиторий, групп или преподавателей) через соответствующие endpoints. Параметры `from` и `to` опциональны, возврат HTTP 400 при некорректных датах.

*Сценарий 4: Получение топ N групп по подписчикам*

Администратор запрашивает наиболее популярные группы по количеству уникальных подписчиков. Параметры: `top` (количество групп, 1-100, по умолчанию 10), `to` (конец периода, опционально). Ответ — JSON массив с объектами с названием группы и количеством подписчиков, или HTTP 400 если `top` вне диапазона 1-100.

*Сценарий 5: Получение топ N групп по просмотрам расписания*

Администратор получает список групп, отсортированный по количеству запросов расписания. Параметры: `top` (1-100, по умолчанию 10), `from` и `to` (опционально). Ответ — JSON массив с объектами групп и количеством запросов, или HTTP 400 при некорректных параметрах.

*Сценарий 6: Получение количества запросов расписания групп*

Администратор запрашивает общее количество запросов на просмотр расписания групп за период. Параметры `from` и `to` опциональны, ответ — целое число запросов или HTTP 400 при некорректных датах.

*Сценарий 7: Получение статистики по настройкам пользователей (текущее состояние)*

Администратор запрашивает количество пользователей с кастомными или дефолтными настройками на текущий момент времени. Параметр `to` опционален (по умолчанию — текущее время). Ответ — целое число пользователей или HTTP 400 при будущей дате.

*Сценарий 8: Получение количества пользователей, выставлявших кастомные настройки*

Администратор запрашивает количество уникальных пользователей, которые выставляли кастомные настройки за период. Параметры `from` и `to` опциональны, ответ — целое число уникальных пользователей или HTTP 400 при некорректных датах.

*Сценарий 9: Получение статистики по поисковым запросам*

Администратор получает количество уникальных пользователей, делавших поиск, или общее количество поисковых запросов. Параметры `from` и `to` опциональны, ответ — целое число (пользователей или запросов в зависимости от endpoint) или HTTP 400 при некорректных датах.

=== Макеты интерфейсов

API документация предоставляется через Swagger UI по адресу `http://localhost:5000/swagger/index.html` при запуске приложения в режиме отладки.

== Требования к программному интерфейсу и используемым ресурсам

=== Требования к программному интерфейсу

*Интеграция с Kafka*: микросервис потребляет события из двух топиков: `suai.user-performed-request` (события о запросах пользователя) и `suai.user-updated-message` (события об обновлении информации пользователя).

*Сообщения Kafka*: оба типа сообщений наследуют от `BaseUserMessage` с полями `TelegramUserId` и `OccuredAt`. Сообщение `UserPerformedRequestMessage` содержит `RequestType` (Search, RoomSchedule, GroupSchedule, TeacherSchedule) и опциональное `GroupName`. Сообщение `UserUpdatedMessage` содержит `UpdateType` (Registered, SubscribedToGroup, SetDefaultSettings, SetCustomSettings) и опциональное `SubscriptionGroupName`.

*REST API endpoints*: StatisticsController предоставляет следующие методы (все методы GET с базовым URL `/api/statistics`). Описание функциональности каждой группы эндпоинтов представлено ниже с соответствующими диаграммами.

// На рисунке @fig-endpoint-registered-users показана структура эндпоинта получения количества зарегистрированных пользователей.
// 
// #figure(
//   image("images/screenshot_1.png", width: 70%),
//   caption: [Структура эндпоинта регистрации пользователей]
// ) <fig-endpoint-registered-users>

// На рисунке @fig-endpoint-schedule-viewers показана архитектура эндпоинтов для получения статистики просмотров расписания по типам.
// 
// #figure(
//   image("images/screenshot_2.png", width: 70%),
//   caption: [Структура эндпоинтов статистики просмотров расписания]
// ) <fig-endpoint-schedule-viewers>

// На рисунке @fig-endpoint-top-groups-subscribers показана схема получения топ групп по количеству подписчиков.
// 
// #figure(
//   image("images/screenshot_3.png", width: 70%),
//   caption: [Структура эндпоинта получения топ групп по подписчикам]
// ) <fig-endpoint-top-groups-subscribers>

// На рисунке @fig-endpoint-top-groups-requests показана организация эндпоинта для получения топ групп по запросам расписания.
// 
// #figure(
//   image("images/screenshot_4.png", width: 70%),
//   caption: [Структура эндпоинта получения топ групп по запросам]
// ) <fig-endpoint-top-groups-requests>

// На рисунке @fig-endpoint-group-schedule-count показана структура эндпоинта подсчёта общего количества запросов расписания групп.
// 
// #figure(
//   image("images/screenshot_5.png", width: 70%),
//   caption: [Структура эндпоинта получения количества запросов расписания групп]
// ) <fig-endpoint-group-schedule-count>

// На рисунке @fig-endpoint-settings-statistics показана архитектура эндпоинтов для получения статистики по пользовательским настройкам.
// 
// #figure(
//   image("images/screenshot_6.png", width: 70%),
//   caption: [Структура эндпоинтов получения статистики по настройкам пользователей]
// ) <fig-endpoint-settings-statistics>

// На рисунке @fig-endpoint-custom-settings-count показена структура эндпоинта получения количества пользователей, изменявших настройки.
// 
// #figure(
//   image("images/screenshot_7.png", width: 70%),
//   caption: [Структура эндпоинта получения количества пользователей со сменённым типом настроек]
// ) <fig-endpoint-custom-settings-count>

// На рисунке @fig-endpoint-search-statistics показана организация эндпоинтов для получения статистики по поисковым запросам.
// 
// #figure(
//   image("images/screenshot_8.png", width: 70%),
//   caption: [Структура эндпоинтов получения статистики по поисковым запросам]
// ) <fig-endpoint-search-statistics>

=== Используемые ресурсы

*Вычислительные ресурсы*: процессор минимум 1 ядро, рекомендуется 2+ ядра для production; память минимум 512 МБ, рекомендуется 1-2 ГБ; диск зависит от объема данных, минимум 10 ГБ для development.

*Внешние зависимости*: PostgreSQL 15+ для хранения данных; Apache Kafka для потребления событий; .NET 9.0 runtime для выполнения приложения; Docker и Docker Compose для контейнеризации.

*Сетевые ресурсы*: порт 5000 для REST API; порт 5433 для подключения к PostgreSQL (в dev режиме); порт для подключения к Kafka (по умолчанию 9092).

#pagebreak()

= Разработка программы

== Проектирование структуры программы

=== Архитектура микросервиса

Микросервис SuaiScheduleBotAnalytics разработан в соответствии с принципами Clean Architecture и состоит из четырех основных слоев:

+ *Domain Layer* (`SuaiScheduleBotAnalytics.Domain`): содержит доменные модели, которые независимы от деталей реализации и внешних зависимостей. На данном уровне определяются бизнес-правила и инварианты.

+ *Application Layer* (`SuaiScheduleBotAnalytics.Application`): содержит бизнес-логику приложения, включая use cases, команды, запросы (queries), валидаторы и потребителей Kafka. Использует паттерн MediatR для управления командами и запросами.

+ *Infrastructure Layer* (`SuaiScheduleBotAnalytics.DataLayer.EF`): реализует интерфейсы репозиториев, работу с БД через Entity Framework Core, миграции и конфигурацию EF.

+ *API Layer* (`SuaiScheduleBotAnalytics.WebApi`): содержит REST контроллеры, конфигурацию Swagger/OpenAPI и middleware для обработки HTTP запросов.
#pagebreak()
=== Взаимосвязь компонентов

На рисунке @fig-system-architecture показана взаимосвязь основных компонентов микросервиса. Система организована в виде многоуровневой архитектуры, где события из Kafka обрабатываются потребителями и преобразуются в команды MediatR. Обработчики команд и запросов взаимодействуют с репозиториями через Entity Framework Core для работы с PostgreSQL. REST API контроллеры предоставляют HTTP интерфейс для получения аналитических данных.

#figure(
```
Kafka Events
    |
    v
[Consumers]  UserPerformedRequestConsumer
             UserUpdatedMessageConsumer
    |
    v
[MediatR]  Commands / Queries
    |
    v
[Repository]  IAnalyticsDbContext
    |
    v
[EF Core]  PostgreSQL
    |
    v
[REST API]  StatisticsController
    |
    v
HTTP Response
```,
  caption: [Архитектурная диаграмма взаимодействия компонентов микросервиса],
)<fig-system-architecture>

== Описание данных и структур данных

=== Основные доменные сущности

В таблице @table-domain-entities представлены основные доменные сущности микросервиса с их свойствами и назначением в системе, включая типы данных и семантику каждого атрибута.

#figure(
  table(
    columns: (1.5fr, 2fr, 3fr),
    align: (left, left, left),
    inset: 6pt,
    [Сущность], [Описание], [Свойства],
    [UserEntity], [Представляет пользователя системы], [• `Id` (long) — первичный ключ, автоинкрементируемое целое число \
• `TelegramId` (long) — уникальный идентификатор в Telegram \
• `RegisteredAt` (DateTimeOffset) — дата и время регистрации \
• `FavoriteGroupId` (long?) — ID группы, на которую подписан пользователь \
• `Requests` (List\<RequestEntity\>) — коллекция запросов пользователя \
• `Updates` (List\<UpdateEntity\>) — события обновления пользователя],
    [GroupEntity], [Представляет академическую группу], [• `Id` (long) — первичный ключ \
• `Name` (string) — название группы (например, "М411") \
• `Users` (List\<UserEntity\>) — пользователи, подписанные на группу \
• `Requests` (List\<RequestEntity\>) — запросы для просмотра расписания \
• `Updates` (List\<UpdateEntity\>) — события обновления, связанные с группой],
    [RequestEntity], [Представляет действие пользователя при просмотре расписания], [• `Id` (long) — первичный ключ \
• `RequestType` (UserRequestTypes) — тип запроса (enum: ViewSchedule, ViewClassroom и т.д.) \
• `OccuredAt` (DateTimeOffset) — временная метка события \
• `UserId` (long?) — ID пользователя, выполнившего запрос \
• `GroupId` (long?) — ID группы, по которой выполнен запрос],
    [UpdateEntity], [Представляет событие обновления информации пользователя], [• `Id` (long) — первичный ключ \
• `UpdateType` (UserUpdateTypes) — тип события (enum: Registered, SubscribedToGroup и т.д.) \
• `OccuredAt` (DateTimeOffset) — временная метка события \
• `UserId` (long?) — ID пользователя \
• `GroupId` (long?) — ID связанной группы],
    [BaseEntity], [Базовый класс для всех сущностей], [• `Id` (long) — первичный ключ \
• `CreatedAt` (DateTimeOffset) — время создания \
• `UpdatedAt` (DateTimeOffset) — время последнего обновления],
  ),
  caption: "Основные доменные сущности системы",
  kind: table
)<table-domain-entities>

=== Словарь данных

Словарь данных представляет все основные параметры и переменные, используемые в системе. В таблице @tbl-data-dictionary приведено описание типов данных, доменных значений и ограничений для каждого элемента данных микросервиса.

#figure(
  long-table(
    columns: (1.6fr, 2fr, 2fr, 1.5fr),
    align: (left, center, center, center),
    inset: 6pt,
    [Поле], [Тип], [Описание], [Ограничения],
    [TelegramUserId], [long], [Идентификатор пользователя в Telegram], [> 0, уникально],
    [OccuredAt], [DateTimeOffset], [Временная метка события], [не в будущем],
    [GroupName], [string], [Название академической группы], [опционально],
    [RequestType], [enum], [Search, RoomSchedule, GroupSchedule, TeacherSchedule], [не null],
    [UpdateType], [enum], [Registered, SubscribedToGroup, SetDefaultSettings, SetCustomSettings], [не null],
    [SubscriptionGroupName], [string?], [Название подписанной группы], [опционально],
    [From], [DateTimeOffset?], [Начало периода фильтрации], [опционально],
    [To], [DateTimeOffset?], [Конец периода фильтрации], [From <= To],
  ),
  caption: "Словарь данных",
  kind: table
)<tbl-data-dictionary>

=== Описание файлов и хранилища

*PostgreSQL база данных* содержит следующие таблицы: `users` (хранит информацию о пользователях); `groups` (хранит информацию о группах); `requests` (хранит запросы пользователей); `updates` (хранит события обновления); `__EFMigrationsHistory` (служебная таблица EF Core для отслеживания миграций).

*Структура файлов проекта*

```
SuaiScheduleBotAnalytics/
├── src/
│   ├── SuaiScheduleBotAnalytics.Domain/        # Доменные модели
│   ├── SuaiScheduleBotAnalytics.Application/   # Бизнес-логика, MediatR
│   │   ├── Kafka/                              # Kafka consumers
│   │   ├── Commands/                           # Команды (create, update)
│   │   ├── Queries/                            # Запросы (read)
│   │   └── Validators/                         # Валидаторы FluentValidation
│   ├── SuaiScheduleBotAnalytics.DataLayer.EF/  # EF Core, репозитории
│   │   ├── Persistence/                        # DbContext, конфигурация
│   │   └── Migrations/                         # Миграции БД
│   ├── SuaiScheduleBotAnalytics.WebApi/        # REST API
│   │   ├── Program.cs                          # Конфигурация приложения
│   │   └── StatisticsController.cs             # API endpoints
│   └── SuaiScheduleBotAnalytics.Models/        # Модели (entities, exceptions)
├── docker-compose-dev.yml                       # Dev окружение
└── docker-compose-production.yml                # Production окружение
```

== Разработка алгоритмов

=== Алгоритм потребления событий запросов пользователей

Алгоритм асинхронной обработки событий о запросах пользователей (UserPerformedRequestConsumer):

+ Приложение инициализирует MassTransit конфигурацию с регистрацией consumers

+ Consumer подписывается на топик `suai.user-performed-request`

+ При поступлении нового сообщения UserPerformedRequestMessage:

  - Извлекается TelegramUserId из сообщения

  - Выполняется проверка существования пользователя в БД через DbContext

  - Если пользователь не найден, создается новая запись UserEntity с текущей временной меткой OccuredAt

  - Сохраняются изменения в базе данных

  - Логируется информация о полученном запросе (UserId, RequestType, GroupName, OccuredAt)

+ Определяется тип запроса через switch по полю RequestType:

  - Search → отправка SearchCommand через MediatR

  - RoomSchedule → отправка RoomScheduleCommand

  - GroupSchedule → валидация наличия GroupName, отправка GroupScheduleCommand

  - TeacherSchedule → отправка TeacherScheduleCommand

+ При отсутствии GroupName для типа GroupSchedule выбрасывается исключение

+ MediatR обрабатывает команду через соответствующий CommandHandler

+ В случае ошибки MassTransit применяет retry logic с повторными попытками

+ Если обработка не удается после всех попыток, сообщение направляется в dead letter queue

=== Алгоритм обработки запроса расписания группы

Алгоритм выполнения команды GroupScheduleCommand (CommandHandler):

+ Получение команды с параметрами: TelegramUserId, GroupName, OccuredAt
+ Логирование начала обработки запроса для пользователя и группы
+ Поиск пользователя в БД по TelegramUserId через FirstAsync (выброс исключения если не найден)
+ Поиск группы по имени (case-insensitive сравнение через StringComparison.InvariantCultureIgnoreCase)
+ Если группа не найдена:
  - Создается новая GroupEntity с нормализованным именем (Trim + ToLowerInvariant)
  - Группа добавляется в DbContext
+ Создается RequestEntity с полями:
  - RequestType = GroupSchedule
  - OccuredAt = временная метка из команды
  - User = найденный пользователь
  - Group = найденная или созданная группа
+ Запись добавляется в коллекцию Requests DbContext
+ Вызов SaveChangesAsync для атомарного сохранения всех изменений
+ Завершение обработки команды

=== Алгоритм потребления событий обновлений пользователей

Алгоритм асинхронной обработки событий об обновлениях (UserUpdatedMessageConsumer):

+ Consumer подписывается на топик `suai.user-updated-message`
+ При поступлении сообщения UserUpdatedMessage:
  - Извлекается TelegramUserId
  - Проверяется существование пользователя в БД
  - Если пользователь отсутствует, создается UserEntity с RegisteredAt = OccuredAt
  - Сохраняются изменения в базе данных
  - Логируется информация об обновлении (UserId, UpdateType, SubscriptionGroupName, OccuredAt)
+ Определяется тип обновления через switch по полю UpdateType:
  - Registered → отправка RegisterUserCommand через MediatR
  - SubscribedToGroup → валидация наличия SubscriptionGroupName, отправка SubscribeUserToGroupCommand
  - SetDefaultSettings → отправка SetUserDefaultSettingsCommand
  - SetCustomSettings → отправка SetUserCustomSettingsCommand
+ При отсутствии SubscriptionGroupName для типа SubscribedToGroup выбрасывается исключение
+ MediatR маршрутизирует команду к соответствующему CommandHandler для обработки
+ Handler выполняет бизнес-логику и сохраняет изменения в БД
+ При успешной обработке возвращается подтверждение в Kafka
+ При ошибке применяется retry logic с exponential backoff для повторных попыток

=== Алгоритм обработки подписки на группу

Алгоритм выполнения команды SubscribeUserToGroupCommand (CommandHandler):

+ Получение команды с параметрами: TelegramUserId, SubscriptionGroupName, OccuredAt
+ Поиск пользователя по TelegramUserId через FirstAsync (исключение если null)
+ Поиск группы по имени через FirstOrDefaultAsync с case-insensitive сравнением
+ Если группа не существует:
  - Создание новой GroupEntity с нормализованным именем (Trim + ToLowerInvariant)
  - Добавление группы в DbContext через AddAsync
+ Создание UpdateEntity с полями:
  - UpdateType = SubscribedToGroup
  - OccuredAt = временная метка из команды
  - User = найденный пользователь
  - UserId = ID пользователя (явное указание FK)
  - Group = найденная или созданная группа
+ Добавление UpdateEntity в коллекцию Updates DbContext
+ Вызов SaveChangesAsync для транзакционного сохранения (группа + событие обновления)
+ Завершение обработки команды

=== Алгоритм получения статистики зарегистрированных пользователей

Алгоритм обработки запроса GetRegisteredUsersCountQuery:

+ Клиент отправляет GET запрос `/api/statistics/registered-users-count?from=date1&to=date2`
+ StatisticsController принимает параметры from и to (опциональные DateTimeOffset)
+ Создается объект GetRegisteredUsersCountQuery с параметрами
+ MediatR маршрутизирует запрос к GetRegisteredUsersCountQueryHandler
+ Handler выполняет валидацию входных параметров:
  - DateRangeValidator.ValidateDateRange(from, to) — проверка что from <= to
  - DateRangeValidator.ValidateNotFuture(from) — проверка что from не в будущем
  - DateRangeValidator.ValidateNotFuture(to) — проверка что to не в будущем
  - При нарушении выбрасывается InvalidDateRangeException или InvalidParameterException
+ Построение LINQ запроса к таблице Updates:
  - Фильтр по UpdateType == Registered
  - Если указан from: фильтр OccuredAt >= from
  - Если указан to: фильтр OccuredAt <= to
+ Выполнение запроса через ToListAsync с загрузкой данных в память
+ Применение Distinct по UserId для исключения дубликатов
+ Подсчет уникальных пользователей через Count()
+ Возврат результата клиенту с HTTP 200
+ При ошибке валидации возвращается HTTP 400 с детальным описанием

=== Алгоритм получения топ групп по количеству запросов

Алгоритм обработки запроса GetTopGroupsByRequestsQuery:

+ Клиент отправляет GET запрос `/api/statistics/top-groups-by-requests?top=10&from=date1&to=date2`
+ StatisticsController принимает параметры: top (int, 1-100), from и to (опциональные)
+ Создается GetTopGroupsByRequestsQuery и передается в MediatR
+ QueryHandler выполняет валидацию:
 - NumericParameterValidator.ValidatePositiveInteger(top, minValue: 1, maxValue: 100)
 - DateRangeValidator.ValidateDateRange(from, to)
 - DateRangeValidator.ValidateNotFuture(from) и ValidateNotFuture(to)
+ Построение LINQ запроса к таблице Requests:
 - Базовый фильтр: RequestType == GroupSchedule И Group != null
 - Если указан from: добавляется фильтр OccuredAt >= from
  - Если указан to: добавляется фильтр OccuredAt <= to
+ Выполнение ToListAsync для загрузки отфильтрованных данных
+ Группировка по названию группы (Group.Name)
+ Для каждой группы подсчитывается TotalRequests = Count() всех запросов (включая дубликаты)
+ Маппинг в TopGroupByRequestsDto с полями GroupName и TotalRequests
+ Сортировка по TotalRequests в порядке убывания (OrderByDescending)
+ Ограничение результата до top элементов через Take(top)
+ Возврат списка TopGroupByRequestsDto клиенту

=== Алгоритм получения топ групп по уникальным подписчикам

Алгоритм обработки запроса GetTopGroupsBySubscribersQuery:

+ Клиент отправляет GET запрос `/api/statistics/top-groups-by-subscribers?top=10&to=date`
+ Получение параметров: top (количество групп, 1-100), to (опциональная дата среза)
+ Валидация параметров:
  - NumericParameterValidator.ValidatePositiveInteger(top, minValue: 1, maxValue: 100)
  - DateRangeValidator.ValidateNotFuture(to)
+ Построение запроса к таблице Updates с Include для Group и User:
  - Фильтр: UpdateType == SubscribedToGroup И Group != null
  - Если указан to: добавляется фильтр OccuredAt <= to
+ Выполнение ToListAsync для получения всех подписок
+ Сортировка по OccuredAt в порядке убывания (последние события первые)
+ Применение DistinctBy(UserId) для выбора последней подписки каждого пользователя
+ Группировка по названию группы (Group.Name)
+ Подсчет уникальных подписчиков в каждой группе через Count()
+ Маппинг в GroupAndSubscribersResponseModel(GroupName, UniqueSubscribers)
+ Сортировка по UniqueSubscribers в порядке убывания
+ Ограничение результата через Take(top)
+ Возврат списка моделей клиенту

=== Алгоритм получения количества пользователей с настройками

Алгоритм обработки запроса GetUsersWithCustomSettingsCountQuery:

+ Клиент отправляет GET запрос `/api/statistics/users-with-custom-settings-count?to=date`
+ Получение параметра to (опциональная временная метка среза)
+ Валидация: если to указан, проверка что дата не в будущем через ValidateNotFuture
+ Построение запроса к таблице Updates:
  - Фильтр: UpdateType IN (SetCustomSettings, SetDefaultSettings)
  - Если указан to: добавляется фильтр OccuredAt <= to
+ Выполнение ToListAsync для загрузки всех событий изменения настроек
+ Сортировка событий по OccuredAt в порядке убывания (последние события первые)
+ Применение DistinctBy(UserId) для получения последнего изменения настроек каждого пользователя
+ Подсчет пользователей, у которых последнее событие имеет UpdateType == SetCustomSettings
+ Возврат количества пользователей с кастомными настройками на момент времени to
+ Аналогично работает GetUsersWithDefaultSettingsCountQuery с фильтром по SetDefaultSettings

=== Алгоритм валидации параметров запросов

Алгоритм валидации диапазона дат (DateRangeValidator):

+ Метод ValidateDateRange(from, to) проверяет корректность временного диапазона:
  - Если оба параметра заданы И from > to:
  - Выбрасывается InvalidDateRangeException
  - Сообщение содержит форматированные даты и описание ошибки
+ Метод ValidateNotFuture(date, parameterName) проверяет что дата не в будущем:
  - Если date задана И date > DateTimeOffset.UtcNow:
  - Выбрасывается InvalidParameterException
  - Сообщение содержит имя параметра, переданную дату и описание
+ Все валидаторы выбрасывают типизированные исключения с детальными сообщениями
+ Исключения перехватываются на уровне WebApi и преобразуются в HTTP 400 ответы

Алгоритм валидации числовых параметров (NumericParameterValidator):

+ Метод ValidatePositiveInteger(value, name, minValue, maxValue) проверяет диапазон:
  - Если value \< minValue ИЛИ value \> maxValue:
  - Выбрасывается InvalidParameterException
  - Сообщение содержит имя параметра, переданное значение и допустимые границы
+ Используется для валидации параметра top в запросах топ-списков (1-100)

#pagebreak()

== Реализация и отладка программы
#v(1em)
=== Конвенция именования

*Переменные*: для локальных переменных и параметров используется стиль camelCase (примеры: userId, requestCount, groupName). Для public свойств классов применяется стиль PascalCase (примеры: TelegramId, RegisteredAt, FavoriteGroup). Private поля имеют префикс подчеркивания (примеры: \_logger, \_mediator, \_dbContext).

*Функции и методы*: все публичные методы именуются в стиле PascalCase с глаголами в названии, такими как Get, Set, Create, Update, Delete, Process (примеры: GetRegisteredUsersCount(), Consume()).

*Классы и типы*: все классы, интерфейсы и перечисления используют стиль PascalCase. Доменные модели имеют суффикс Entity (примеры: UserEntity, GroupEntity). Kafka потребители имеют суффикс Consumer (примеры: UserPerformedRequestConsumer). MediatR объекты имеют суффиксы Query, Command, Handler. REST контроллеры имеют суффикс Controller. Интерфейсы имеют префикс I (примеры: IAnalyticsDbContext, IAnalyticsReadRepository).

*Модули и пространства имен*: структурированы по архитектурным слоям (Application, Domain, Infrastructure) с дополнительными папками для группировки логики (Kafka, Commands, Queries, Persistence).

=== Стиль оформления кода

Отступы в коде составляют 4 пробела (стандарт .NET). Комментирование включает XML документацию для public методов, inline комментарии для сложной логики, TODO комментарии для будущих улучшений, при этом самоочевидный код не комментируется. Разбиение на файлы предусматривает один класс в одном файле, вспомогательные классы могут находиться в одном файле, размер файла не превышает 300 строк.

=== Описание модулей

*SuaiScheduleBotAnalytics.Domain* содержит базовый класс BaseEntity, используемый всеми доменными сущностями. На этом слое отсутствует бизнес-логика, поэтому модуль остается независимым от деталей реализации.

*SuaiScheduleBotAnalytics.Application* является основным слоем бизнес-логики. Включает Kafka потребителей для обработки событий из очереди сообщений, MediatR команды и запросы для операций с данными, валидаторы входных данных с использованием FluentValidation, и интерфейсы для определения контрактов компонентов.

*SuaiScheduleBotAnalytics.DataLayer.EF* реализует слой доступа к данным. Содержит AnalyticsDbContext для конфигурации Entity Framework Core, конфигурацию сущностей через entity configurations, миграции баз данных, и реализацию репозиториев для работы с хранилищем.

*SuaiScheduleBotAnalytics.WebApi* содержит API слой приложения. Включает Program.cs с конфигурацией DI контейнера для внедрения зависимостей, StatisticsController с REST endpoints для получения аналитики, middleware для глобальной обработки ошибок (где требуется), и конфигурацию Swagger для документации API.

=== Описание основных функций и методов

В таблице @tbl-functions описаны основные функции и методы микросервиса, включая их сигнатуры, входные и выходные параметры, а также предназначение в системе аналитики.

#figure(
  long-table(
    columns: (1.5fr, 1.2fr, 2fr, 1.8fr, 1.5fr, 0.8fr),
    align: (left, left, left, left, left, left),
    inset: 6pt,
    [Класс], [Имя\ метода,\ функции], [Прототип], [Назначение], [Входные данные], [Выходные данные],
    [User
    Performed
    Request
    Consumer], [Consume], [Task Consume
    (ConsumeContext
    \<UserPerformed
    RequestMessage\> context)], [Обработка события просмотра расписания из Kafka и сохранение в БД], [context], [-],
    [GetRegistered
    UsersCount
    QueryHandler], [Handle], [Task\<int\> Handle
    (GetRegistered
    UsersCountQuery query,
    CancellationToken
    cancellationToken)], [Получение количества зарегистрировавшихся пользователей за период с валидацией диапазона дат], [query, cancellationToken], [int],
    [GetGroup
    Schedule
    Requests
    Count
    QueryHandler], [Handle], [Task\<int\> Handle
    (GetGroup
    Schedule
    RequestsCount
    Query query,
    CancellationToken
    cancellationToken)], [Получение количества запросов на просмотр расписания групп за период], [query, cancellation
    Token], [int],
    [RegisterUser
    Command
    Handler], [Handle], [Task Handle
    (RegisterUser
    Command command,
    CancellationToken
    cancellationToken)], [Создание записи события регистрации пользователя в БД], [command, cancellation
    Token
    ], [-],
    [Group
    Schedule
    Command
    Handler], [Handle], [Task Handle
    (GroupSchedule
    Command command,
    CancellationToken
    cancellationToken)], [Добавление записи о запросе расписания группы с созданием группы при необходимости], [command, cancellation
    Token], [-],
    [SearchRequest
    Handler], [Handle], [Task Handle
    (SearchCommand
    command,
    CancellationToken
    cancellationToken)], [Добавление записи о поисковом запросе пользователя в БД], [command, cancellationToken], [-],
    [RoomSchedule
    CommandHandler], [Handle], [Task Handle
    (RoomSchedule
    Command command,
    CancellationToken
    cancellationToken)], [Добавление записи о запросе расписания аудитории в БД], [command, cancellationToken], [-],
    [TeacherSchedule
    CommandHandler], [Handle], [Task Handle
    (TeacherSchedule
    Command command,
    CancellationToken
    cancellationToken)], [Добавление записи о запросе расписания преподавателя в БД], [command, cancellationToken], [-],
    [SubscribeUser
    ToGroup
    CommandHandler], [Handle], [Task Handle
    (SubscribeUser
    ToGroup
    Command command,
    CancellationToken
    cancellationToken)], [Создание записи события подписки пользователя на группу с созданием группы при необходимости], [command, cancellationToken], [-],
    [SetUserCustom
    SettingsCommand
    Handler], [Handle], [Task Handle
    (SetUserCustom
    SettingsCommand
    command,
    CancellationToken
    cancellationToken)], [Создание записи события установки пользовательских настроек], [command, cancellationToken], [-],
    [GetTopGroupsBy
    SubscribersQuery
    Handler], [Handle], [Task\<List\<Group
    AndSubscribers
    ResponseModel\>\>
    Handle
    (GetTopGroupsBy
    SubscribersQuery
    query,
    CancellationToken
    cancellationToken)], [Получение топ N групп по количеству уникальных подписчиков с валидацией параметров], [query, cancellationToken], [List\<Group
    AndSubscribers
    ResponseModel\>],
    [GetTopGroupsBy
    RequestsQuery
    Handler], [Handle], [Task\<List\<Top
    GroupByRequests
    Dto\>\> Handle
    (GetTopGroupsBy
    RequestsQuery query,
    CancellationToken
    cancellationToken)], [Получение топ N групп по количеству запросов расписания с валидацией диапазона дат], [query, cancellationToken], [List\<Top
    GroupByRequests
    Dto\>],
    [GetUnique
    ScheduleViewers
    CountQuery
    Handler], [Handle], [Task\<int\> Handle
    (GetUnique
    ScheduleViewers
    CountQuery query,
    CancellationToken
    cancellationToken)], [Получение количества уникальных пользователей, просмотревших расписание (любого типа) за период], [query, cancellationToken], [int],
    [DateRange
    Validator], [ValidateDateRange], [void ValidateDateRange
    (DateTimeOffset? from,
    DateTimeOffset? to)], [Валидация корректности диапазона дат (from не позже to)], [from, to], [-],
    [DateRange
    Validator], [ValidateNotFuture], [void ValidateNotFuture
    (DateTimeOffset? date,
    string parameterName)], [Валидация что дата не находится в будущем], [date, parameterName], [-],
    [NumericParameter
    Validator], [ValidatePositive
    Integer], [void ValidatePositive
    Integer
    (int value,
    string parameterName,
    int minValue,
    int maxValue)], [Валидация что числовой параметр находится в допустимом диапазоне], [value, parameterName, minValue, maxValue], [-],
  ),
  caption: "Описание основных функций и методов",
  kind: table
)<tbl-functions>

=== Оптимизация кода

*Оптимизация производительности* достигается использованием асинхронных операций (async/await) для non-blocking I/O, query splitting в Entity Framework Core для оптимизации запросов с Include(), использованием индексов на часто используемых полях (UserId, GroupId, OccuredAt), кэшированием результатов часто запрашиваемых данных.

*Оптимизация объема кода* включает использование DI контейнера для избежания дублирования логики, применение паттернов MediatR и Repository для уменьшения связанности компонентов, использование интерфейсов для абстрагирования реализации.

*Масштабируемость системы* обеспечивается микросервисной архитектурой, которая позволяет масштабировать компоненты независимо. Асинхронная обработка через Kafka позволяет обрабатывать пиковые нагрузки без перегруженности. Stateless дизайн API позволяет горизонтальное масштабирование приложения.

=== Средства отладки

Для отладки приложения используются следующие инструменты: Jetbrains Rider для интерактивной отладки приложения с breakpoints и пошаговым выполнением, Jetbrains DataGrip для просмотра и анализа данных в PostgreSQL, Kafka UI для мониторинга топиков Kafka и анализа сообщений в очередях, Application Insights для мониторинга production приложения и сбора телеметрии, structured logging с Serilog для структурированного анализа логов и отслеживания проблем, Swagger UI для тестирования REST API endpoints и проверки контрактов.

#pagebreak()

= Тестирование

== Цели и организация тестирования

Тестирование микросервиса выполнялось с целью проверки корректности реализации всех функциональных требований, определенных в разделе 2.1. Все тестовые сценарии реализованы в виде автоматизированных модульных тестов с использованием фреймворка Xunit.

== Описание тестовых сценариев

Разработана комплексная система тестирования, покрывающая все уровни приложения. В таблице @table-test-technologies представлены основные тестовые классы, организованные по слоям приложения с указанием их назначения и проверяемых функций.

#figure(
  long-table(
    columns: (1.8fr, 1.8fr, 3fr),
    align: (horizon, horizon, left),
    inset: 6pt,
    [*Тестовый класс*], [*Описание*],[*Проверяемая функциональность*],
    table.cell(colspan: 3, align: center)[Application Layer — Query Handlers (обработчики запросов статистики)],
    [GetRegisteredUsers
    CountQueryHandler
  Tests], [Тестирование подсчета пользователей], [• Проверка получения общего количества зарегистрированных пользователей без применения фильтров \
• Проверка фильтрации по дате начала периода \
• Проверка фильтрации по дате окончания периода \
• Проверка фильтрации по диапазону дат с указанием начала и окончания периода ],
    [GetUniqueSchedule
    ViewersCountQuery
    HandlerTests], [Тестирование уникальных просмотров расписания], [• Проверка подсчета уникальных пользователей по всем типам просмотров расписания (аудиторий, групп, преподавателей) \
• Проверка исключения дубликатов запросов от одного пользователя \
• Проверка исключения поисковых запросов из статистики \
• Проверка фильтрации результатов по временным периодам],
    [GetGroupSchedule
    RequestsCountQuery
    HandlerTests], [Подсчет просмотров расписания групп], [• Проверка подсчета всех запросов на просмотр расписания групп за указанный период \
• Проверка исключения из подсчета запросов других типов \
• Проверка корректности применения фильтрации по дате начала и окончания периода],
    [GetTopGroupsBy
    RequestsQuery
    HandlerTests], [Получение топ-групп по количеству просмотров], [• Проверка корректности сортировки групп по количеству запросов в порядке убывания \
• Проверка ограничения количества результатов параметром top \
• Проверка подсчета всех запросов включая повторные от одного пользователя \
• Проверка корректности работы при наличии нескольких групп],
    [GetTopGroupsBy
    SubscribersQuery
    HandlerTests], [Получение топ-групп по количеству подписчиков], [• Проверка корректности сортировки групп по количеству уникальных подписчиков в порядке убывания \
• Проверка ограничения количества результатов параметром top \
• Проверка исключения повторных подписок одного пользователя \
• Проверка фильтрации результатов по датам подписок],
    [ScheduleViewersBy
    TypeQueryHandler
    Tests], [Статистика просмотров по типам запросов], [• Проверка работы запроса получения уникальных пользователей, просмотревших расписание аудиторий \
• Проверка работы запроса получения уникальных пользователей, просмотревших расписание групп \
• Проверка работы запроса получения уникальных пользователей, просмотревших расписание преподавателей \
• Проверка применения фильтрации по временным периодам для всех типов запросов],
    [UserSettingsQuery
    HandlerTests], [Статистика по настройкам пользователей], [• Проверка работы запроса получения количества пользователей с кастомными настройками \
• Проверка работы запроса получения количества пользователей с дефолтными настройками \
• Проверка работы запроса получения количества пользователей, устанавливавших кастомные настройки \
• Проверка учета только последнего обновления настроек пользователя \
• Проверка игнорирования событий других типов \
• Проверка фильтрации результатов по временным периодам],
    [SearchQueryHandler
    Tests], [Тестирование функциональности поиска], [• Проверка работы запроса получения уникальных пользователей, выполнивших поиск \
• Проверка подсчета уникальных пользователей без учета повторных поисковых запросов \
• Проверка исключения дубликатов при подсчете пользователей \
• Проверка фильтрации результатов по диапазону дат \
• Проверка исключения из подсчета запросов других типов],
    [QueryValidationTests], [Комплексная валидация входных параметров], [• Проверка выброса исключения InvalidDateRangeException при указании даты начала позже даты окончания \
• Проверка выброса исключения InvalidParameterException при указании дат в будущем \
• Проверка выброса исключения InvalidParameterException при указании значения параметра top вне допустимого диапазона от 1 до 100],
    table.cell(colspan: 3, align: center)[Application Layer — Validators (валидаторы входных данных)],
    [DateRangeValidator
    Tests], [Валидация диапазонов дат], [• Проверка метода ValidateDateRange на корректность валидации условия, что дата начала не может быть позже даты окончания \
• Проверка метода ValidateNotFuture на корректность валидации условия, что указанная дата не может быть в будущем \
• Проверка позитивных сценариев с корректным диапазоном дат, равными датами и значениями null \
• Проверка негативных сценариев с некорректным диапазоном и датами в будущем \
• Проверка корректности формата сообщений об ошибках с указанием дат в формате ISO],
    [NumericParameter
    ValidatorTests], [Валидация числовых параметров], [• Проверка метода ValidatePositiveInteger для параметров top, limit, count на соответствие допустимым диапазонам значений \
• Проверка диапазонов со значениями по умолчанию от 1 до 1000 и специальным диапазоном для параметра top от 1 до 100 \
• Проверка корректности обработки граничных значений (минимум и максимум диапазона) \
• Проверка возможности задания кастомных диапазонов для различных параметров \
• Проверка корректности формирования сообщений об ошибках с указанием допустимых границ значений],
    table.cell(colspan: 3, align: center)[WebApi Layer — Middleware (обработка исключений)],
    [ExceptionHandling
    MiddlewareTests], [Преобразование исключений в HTTP статус-коды], [• Проверка преобразования исключений ArgumentNullException, ArgumentException, ArgumentOutOfRangeException, FormatException в HTTP статус-код 400 \
• Проверка преобразования InvalidOperationException в HTTP статус-код 409 (или 404 для исключения с текстом "Sequence contains no elements") \
• Проверка преобразования KeyNotFoundException в HTTP статус-код 404 \
• Проверка преобразования UnauthorizedAccessException в HTTP статус-код 403 \
• Проверка преобразования OperationCanceledException в HTTP статус-код 499 \
• Проверка преобразования кастомных исключений InvalidDateRangeException, InvalidParameterException, ValidationException в HTTP статус-код 400 \
• Проверка преобразования необработанных исключений в HTTP статус-код 500 \
• Проверка корректности формата ответа application/json с наличием полей status и detail \
• Проверка отсутствия стек-трейсов в production окружении],
  ),
  caption: "Структура и назначение основных тестовых классов",
  kind: table
)<table-test-scenarios>

== Результаты тестирования

В таблице @tbl-test-results представлены результаты выполнения основных тестовых сценариев. Каждый сценарий проверяет определённый функциональный аспект системы, включая получение статистики, фильтрацию данных, валидацию параметров и обработку ошибок в различных компонентах микросервиса.

#figure(
  long-table(
    columns: (auto, 1fr, 1.5fr, 1.2fr, 0.8fr),
    align: horizon,
    [№], [Название теста], [Тестовые данные], [Ожидаемый результат], [Статус],
    [1], [Получение общего количества пользователей], [3 пользователя (01.2024, 02.2024, 03.2024), фильтры: from=null, to=null], [Количество: 3], [Успешно выполнен],
    
    [2], [Фильтрация пользователей по дате начала], [3 пользователя, фильтр: from=15.02.2024, to=null], [Количество: 2 (пользователи с 15.02.2024 и позже)], [Успешно выполнен],
    
    [3], [Фильтрация пользователей по дате окончания], [3 пользователя, фильтр: from=null, to=10.02.2024], [Количество: 2 (пользователи до 10.02.2024 включительно)], [Успешно выполнен],
    
    [4], [Подсчет уникальных пользователей], [2 пользователя, 4 запроса (1 пользователь выполнил 3 запроса)], [Количество уникальных: 2], [Успешно выполнен],
    
    [5], [Исключение поисковых запросов из статистики], [2 пользователя: 1 просмотр расписания, 1 поиск], [Количество уникальных: 1 (только просмотры расписания)], [Успешно выполнен],
    
    [6], [Топ групп по количеству просмотров], [3 группы: group-a (4 запроса), group-b (2), group-c (1)], [Список отсортирован: group-a, group-b, group-c с соответствующими счетчиками], [Успешно выполнен],
    
    [7], [Ограничение количества результатов], [5 групп с запросами, параметр top=2], [Возвращается ровно 2 группы], [Успешно выполнен],
    [8], [Валидация: корректный диапазон дат], [from=01.01.2024, to=31.12.2024], [Исключение не выбрасывается], [Успешно выполнен],
    
    [9], [Валидация: равные даты], [from=15.06.2024, to=15.06.2024], [Исключение не выбрасывается (допустимо)], [Успешно выполнен],
    
    [10], [Валидация: обе даты null], [from=null, to=null], [Исключение не выбрасывается (фильтрация отсутствует)], [Успешно выполнен],
    
    [11], [Ошибка: некорректный диапазон дат], [from=31.12.2024, to=01.01.2024], [InvalidDateRange Exception с сообщением "не может быть позже"], [Успешно выполнен],
    
    [12], [Ошибка: дата в будущем], [from=дата через 10 дней от текущей], [InvalidParameter Exception с сообщением "содержит будущую дату"], [Успешно выполнен],
    
    [13], [Валидация числовых параметров: допустимое значение], [top=50, min=1, max=100], [Исключение не выбрасывается], [Успешно выполнен],
    
    [14], [Ошибка: параметр меньше минимума], [top=0, min=1, max=100], [InvalidParameter Exception: "имеет некорректное значение", "Минимально: 1"], [Успешно выполнен],
    
    [15], [Ошибка: параметр больше максимума], [top=101, min=1, max=100], [InvalidParameter Exception: "имеет некорректное значение", "Максимально: 100"], [Успешно выполнен],
    
    [16], [Обработка Argument NullException], [Middleware получает ArgumentNullException], [HTTP 400 + "Некорректные параметры запроса"], [Успешно выполнен],
    
    [17], [Обработка KeyNotFound Exception], [Middleware получает KeyNotFoundException], [HTTP 404 + "Запрашиваемый ресурс не найден"], [Успешно выполнен],
    
    [18], [Обработка Invalid Operation Exception], [Middleware получает InvalidOperationException], [HTTP 409 + "Операция не может быть выполнена"], [Успешно выполнен],
    
    [19], [Обработка неизвестного исключения], [Middleware получает Exception("boom")], [HTTP 500 + "Внутренняя ошибка сервиса"], [Успешно выполнен],
    
    [20], [Обработка InvalidDate Range Exception], [Middleware получает InvalidDateRangeException с описанием диапазона], [HTTP 400, сообщение содержит детали о некорректном диапазоне], [Успешно выполнен],
    
    [21], [Подсчет запросов на просмотр расписания групп], [3 запроса GroupSchedule, 1 RoomSchedule, 1 TeacherSchedule, 1 Search], [Количество: 3 (только GroupSchedule)], [Успешно выполнен],
    
    [22], [Топ групп по подписчикам с уникальностью], [group-a: 3 уникальных подписчика, group-b: 2, group-c: 1], [Список отсортирован: group-a (3), group-b (2), group-c (1)], [Успешно выполнен],
    
    [23], [Повторная подписка одного пользователя], [1 пользователь подписался 3 раза на одну группу], [Количество уникальных подписчиков: 1], [Успешно выполнен],
    
    [24], [Подсчет просмотров по типу: RoomSchedule], [2 пользователя просмотрели RoomSchedule, 1 — GroupSchedule], [Количество уникальных: 2 (только RoomSchedule)], [Успешно выполнен],
    
    [25], [Подсчет просмотров по типу: GroupSchedule], [2 пользователя просмотрели GroupSchedule, 1 — RoomSchedule], [Количество уникальных: 2 (только GroupSchedule)], [Успешно выполнен],
    
    [26], [Подсчет просмотров по типу: Teacher Schedule], [2 пользователя просмотрели TeacherSchedule, 1 — RoomSchedule], [Количество уникальных: 2 (только TeacherSchedule)], [Успешно выполнен],
    
    [27], [Статистика настроек: последнее обновление], [user1: default→custom (last), user2: custom→default (last)], [Custom: 1 (user1), Default: 1 (user2)], [Успешно выполнен],
    
    [28], [Игнорирование событий не-настроек], [1 SetCustomSettings, 1 Registered, 1 SubscribedToGroup для одного пользователя], [Количество с custom настройками: 1], [Успешно выполнен],
    
    [29], [Подсчет пользователей, выполнявших поиск], [3 пользователя, каждый выполнил запрос Search], [Количество уникальных: 3], [Успешно выполнен],
    
    [30], [Исключение дубликатов в поиске], [1 пользователь выполнил 3 поисковых запроса], [Количество уникальных: 1], [Успешно выполнен],
    
    [31], [Фильтрация поиска по датам], [3 пользователя искали в разные даты (01.2024, 02.2024, 03.2024), диапазон: 02-03.2024], [Количество: 2 (исключен январь)], [Успешно выполнен],
    
    [32], [Валидация GetTopGroups ByRequests Query: top=0], [Параметр top=0, min=1], [InvalidParameter Exception с указанием минимума], [Успешно выполнен],
    
    [33], [Валидация GetTopGroups ByRequests Query: top=-5], [Параметр top=-5, min=1], [InvalidParameter Exception с указанием минимума], [Успешно выполнен],
    
    [34], [Валидация GetTopGroups BySubscribers Query: top вне диапазона], [Параметр top=101, max=100], [InvalidParameter Exception с указанием максимума], [Успешно выполнен],
    
    [35], [Валидация дат в GetUnique Schedule Viewers CountQuery], [from=31.12.2024, to=01.01.2024], [InvalidDate RangeException], [Успешно выполнен],
    
    [36], [Валидация дат в GetGroup Schedule Requests CountQuery], [from=30.06.2024, to=01.01.2024], [InvalidDate RangeException], [Успешно выполнен],
    
    [37], [Обработка Format Exception], [Middleware получает FormatException], [HTTP 400 + "Некорректный формат данных"], [Успешно выполнен],
    
    [38], [Обработка Unauthorized Access Exception], [Middleware получает Unauthorized Access Exception], [HTTP 403 + "Доступ запрещен"], [Успешно выполнен],
    
    [39], [Обработка Operation Canceled Exception], [Middleware получает OperationCanceled Exception], [HTTP 499 + "Запрос был отменен"], [Успешно выполнен],
    
    [40], [Обработка Invalid  Operation Exception с "no elements"], [Middleware получает InvalidOperation Exception("Sequence contains no elements")], [HTTP 404 + "Запрашиваемые данные не найдены"], [Успешно выполнен],
    
    [41], [Middleware пропускает запросы без ошибок], [Запрос обработан успешно без исключений], [HTTP 204 No Content, пустое тело ответа], [Успешно выполнен],
    
    [42], [Формат JSON ответа middleware], [Любое исключение], [Content-Type: application/json, поля: status, detail], [Успешно выполнен],
    
    [43], [Фильтрация по диапазону дат для GetRegistered UsersCount Query], [3 пользователя (01.2024, 02.2024, 03.2024), диапазон: 01.02-28.02.2024], [Количество: 1 (только февраль)], [Успешно выполнен],
    
    [44], [Валидация DateRange: from=null, корректное поведение], [from=null, to=31.12.2024], [Исключение не выбрасывается, фильтрация только по to], [Успешно выполнен],
    
    [45], [Валидация DateRange: to=null, корректное поведение], [from=01.01.2024, to=null], [Исключение не выбрасывается, фильтрация только по from], [Успешно выполнен],
    
    [46], [Топ групп по запросам: несколько пользователей на одну группу], [group-a: 1 пользователь выполнил 3 запроса, 1 пользователь - 2 запроса], [Total requests: 5 для group-a], [Успешно выполнен],
    
    [47], [Топ групп по подписчикам: ограничение по датам], [3 группы с подписчиками в разные даты, фильтр by date], [Возвращаются только группы в указанном диапазоне], [Успешно выполнен],
    
    [48], [GetUnique Schedule Viewers CountQuery: фильтрация по диапазону], [4 пользователя просмотрели расписание в разные даты, from=date2, to=date3], [Количество: 2 (в диапазоне)], [Успешно выполнен],
    
    [49], [GetGroup Schedule Requests CountQuery: фильтрация по to], [3 запроса в разные даты (01.2024, 02.2024, 03.2024), to=10.02.2024], [Количество: 2 (до 10.02 включительно)], [Успешно выполнен],
    
    [50], [GetGroup Schedule Requests CountQuery: фильтрация по диапазону], [3 запроса, from=01.02.2024, to=28.02.2024], [Количество: 1 (только в феврале)], [Успешно выполнен],
    
    [51], [Топ групп по запросам: фильтрация по диапазону дат], [3 группы с запросами в разные даты, диапазон: 01-31.02.2024], [Возвращаются только запросы в указанном диапазоне], [Успешно выполнен],
    
    [52], [Топ групп по запросам: пустой результат при отсутствии данных], [База данных пуста], [Возвращается пустой список], [Успешно выполнен],
    
    [53], [Топ групп по подписчикам: пустой результат], [База данных пуста или нет подписок], [Возвращается пустой список], [Успешно выполнен],
    
    [54], [GetUnique Schedule Viewers CountQuery: пустой результат], [База данных пуста], [Возвращается 0], [Успешно выполнен],
    
    [55], [GetRegistered Users CountQuery: пустой результат], [База данных пуста], [Возвращается 0], [Успешно выполнен],
    
    [56], [Валидация чисел: граничные значения min], [top=1 (минимум), min=1, max=100], [Исключение не выбрасывается], [Успешно выполнен],
    
    [57], [Валидация чисел: граничные значения max], [top=100 (максимум), min=1, max=100], [Исключение не выбрасывается], [Успешно выполнен],
    
    [58], [Валидация чисел: кастомный диапазон 5-10], [value=7, min=5, max=10], [Исключение не выбрасывается], [Успешно выполнен],
    
    [59], [Валидация чисел: кастомный диапазон, ниже минимума], [value=4, min=5, max=10], [InvalidParameter Exception], [Успешно выполнен],
    
    [60], [Валидация чисел: кастомный диапазон, выше максимума], [value=11, min=5, max=10], [InvalidParameter Exception], [Успешно выполнен],
    
    [61], [Валидация чисел: проверка дефолтного диапазона], [value=500, no min/max specified (default 1-1000)], [Исключение не выбрасывается], [Успешно выполнен],
    
    [62], [Валидация чисел: превышение дефолтного максимума], [value=1001, default max=1000], [InvalidParameter  Exception с упоминанием 1000], [Успешно выполнен],
    
    [63], [Валидация чисел: сообщение содержит имя параметра], [Любой некорректный параметр "mySpecialParameter"], [InvalidParameter Exception. ParameterName == "mySpecial Parameter"], [Успешно выполнен],
    
    [64], [DateRange валидация: дата в прошлом валидна], [Дата 30 дней назад], [Исключение не выбрасывается], [Успешно выполнен],
    
    [65], [DateRange валидация: null дата валидна], [date=null], [Исключение не выбрасывается], [Успешно выполнен],
    
    [66], [DateRange валидация: сообщение содержит ISO даты], [from=2024-12-31, to=2024-01-01], [Сообщение содержит "2024-12-31" и "2024-01-01"], [Успешно выполнен],
    
    [67], [UserSettings: нулевой результат при отсутствии настроек], [База данных не содержит событий настроек], [Custom: 0, Default: 0], [Успешно выполнен],
    
    [68], [User Settings: множественные изменения одного пользователя], [user1: default→custom→ default→custom], [Учитывается только последнее: custom], [Успешно выполнен],
    
    [69], [UsersWho SetCustom Settings: исключение SetDefault Settings], [2 пользователя: 1 SetCustomSettings, 1 SetDefaultSettings], [Количество: 1 (только custom)], [Успешно выполнен],
    
    [70], [UsersWho SetCustom Settings: без дубликатов], [1 пользователь установил custom 3 раза], [Количество: 1 (distinct)], [Успешно выполнен],
    
    [71], [Search: исключение других типов запросов], [3 пользователя: 2 Search, 1 GroupSchedule], [Количество: 2 (только Search)], [Успешно выполнен],
    
    [72], [Schedule Viewers: RoomSchedule без дубликатов], [1 пользователь выполнил 3 RoomSchedule запроса], [Количество: 1 (distinct)], [Успешно выполнен],
    
    [73], [Schedule Viewers: GroupSchedule без дубликатов], [1 пользователь выполнил 3 GroupSchedule запроса], [Количество: 1 (distinct)], [Успешно выполнен],
    
    [74], [Schedule Viewers: Teacher Schedule без дубликатов], [1 пользователь выполнил 3 TeacherSchedule запроса], [Количество: 1 (distinct)], [Успешно выполнен],
    
    [75], [Schedule Viewers: фильтрация по датам для всех типов], [3 пользователя просмотрели RoomSchedule в разные даты, диапазон: date2-date3], [Количество: 2 (в диапазоне)], [Успешно выполнен],
    
    [76], [Validation Exception: обработка как 400], [Middleware получает ValidationException ("Общая ошибка валидации")], [HTTP 400 + "Общая ошибка валидации"], [Успешно выполнен],
    
    [77], [Middleware: формат ответа только status и detail], [Любое исключение (например, InvalidParameter Exception)], [Response содержит только поля status и detail, нет стек-трейса], [Успешно выполнен],
  ),
  caption: "Результаты тестирования основных сценариев",
  kind: table
)<tbl-test-results>>

== Статистика покрытия тестами

Всего разработано 12 тестовых классов с более чем 100 индивидуальными тестовыми случаями. Все тесты успешно пройдены, что подтверждает корректность реализации функциональных требований микросервиса.

В таблице @table-test-coverage представлена детализация покрытия тестами по классам и слоям приложения, включая количество тестовых методов и описание проверяемой функциональности для каждого компонента системы.

#figure(
  long-table(
    columns: (2fr, auto, 2fr),
    align: (left, center, center),
    inset: 6pt,
    [Тестовый класс], [Кол-во тестов], [Описание],
    table.cell(colspan: 3, align: center)[Application Layer (Queries)],
 [GetRegisteredUsersCount
 QueryHandlerTests], [5], [Подсчет зарегистрированных пользователей с фильтрацией],
    
     [GetUniqueScheduleViewersCount
     QueryHandlerTests], [6], [Подсчет уникальных пользователей, просматривавших расписание],
    
     [GetGroupScheduleRequests
     CountQueryHandlerTests], [6], [Количество просмотров расписания групп],
    
     [GetTopGroupsByRequestsQuery
     HandlerTests], [8], [Топ групп по количеству запросов],
    
     [GetTopGroupsBySubscribersQuery
     HandlerTests], [8], [Топ групп по количеству подписчиков],
    
     [ScheduleViewersByTypeQuery
     HandlerTests], [6], [Статистика просмотров по типам (Room, Group, Teacher)],
    
     [SearchQueryHandlerTests], [6], [Статистика поисковых запросов],
    
     [UserSettingsQueryHandlerTests], [7], [Статистика по настройкам пользователей],
    
     [QueryValidationTests], [12+], [Валидация параметров всех query handlers],
    table.cell(colspan: 3, align: center)[Application Layer (Validators)], 
    [DateRangeValidatorTests], [9], [Валидация диапазонов дат],
    
     [NumericParameterValidatorTests], [20+], [Валидация числовых параметров (8 параметризованных тестов)],
    
    table.cell(colspan: 3, align: center)[WebApi Layer], [ExceptionHandlingMiddlewareTests], [8+], [Обработка исключений и HTTP статус-коды],
  ),
  caption: "Покрытие тестами по слоям и компонентам приложения",
  kind: table
)<table-test-coverage>

В таблице @table-test-technologies представлены типы и цели проверяемых тестовых сценариев, применяемые при верификации функциональности микросервиса, включая позитивные, негативные и граничные случаи, а также сценарии функциональной проверки и валидации входных данных.

#figure(
  table(
    columns: (1fr, 2fr),
    align: (center, left),
    inset: 6pt,
    [Тип сценария], [Описание и проверяемая функциональность],
    [Позитивные], [Проверка корректной работы системы при валидных входных данных и нормальных условиях функционирования],
    [Негативные], [Проверка обработки ошибок и корректного поведения при некорректных или неожиданных данных],
    [Граничные], [Проверка поведения при null параметрах, равных датах, экстремальных значениях и пустых наборах данных],
    [Фильтрация и сортировка], [Проверка корректности выборки и упорядочения результатов по различным критериям],
    [Валидация входных параметров], [Проверка выявления и обработки некорректных значений всех API endpoints],
    [Отображение исключений], [Проверка корректного преобразования исключений в HTTP статус-коды для коммуникации ошибок],
  ),
  caption: "Типы и описание проверяемых тестовых сценариев",
  kind: table
)<table-test-scenarios>

В таблице @table-test-technologies представлены основные технологии и инструменты, используемые при разработке и выполнении тестового покрытия микросервиса, включая фреймворки, библиотеки и методики параметризованного тестирования и верификации результатов.

#figure(
  table(
    columns: (1fr, 2fr),
    align: (center, left),
    inset: 6pt,
    [Технология], [Назначение и область применения],
    [Xunit], [Фреймворк для модульного тестирования в .NET с удобным синтаксисом и расширяемостью],
    [InMemoryDatabase], [Обеспечение изоляции тестов базы данных без подключения к реальной БД через Entity Framework Core],
    [Theory и InlineData], [Параметризованное тестирование с множеством входных значений в одном тесте],
    [Assert методы], [Проверка ожидаемых результатов через Equal, Throws, Contains и другие проверки],
    [Record.Exception], [Перехват и проверка исключений для верификации обработки ошибок],
  ),
  caption: "Используемые технологии и инструменты тестирования",
  kind: table
)<table-test-technologies>

== Выводы по тестированию

Все разработанные функциональные возможности микросервиса прошли успешное тестирование. Проверены как успешные сценарии работы (получение статистики с различными фильтрами), так и режимы обработки ошибок (некорректные параметры, отсутствующие данные, исключительные ситуации).

Использование in-memory базы данных и параметризованных тестов обеспечивает высокую скорость выполнения тестов и их независимость друг от друга. Каждый тест создает изолированное окружение, что гарантирует воспроизводимость результатов.

Тестовое покрытие включает все критические компоненты системы: обработчики запросов, валидаторы входных данных и middleware обработки ошибок. Все тесты выполняются успешно, что подтверждает корректность реализации требований.

#pagebreak()

#ch("Заключение")

В ходе выполнения курсовой работы была успешно разработана система аналитики для Telegram-бота расписания ГУАП — микросервис SuaiScheduleBotAnalytics, который решает задачу сбора, хранения и анализа метрик использования основного приложения.

*Достигнутые результаты*:

Спроектирована архитектура микросервиса в соответствии с принципами Clean Architecture, обеспечивающая четкое разделение ответственности и легкость тестирования.

Реализованы четыре архитектурных слоя приложения: Domain определяет доменные сущности (User, Group, Request, Update), Application реализует бизнес-логику через MediatR команды и запросы с потребителями Kafka, Infrastructure настраивает работу с PostgreSQL через Entity Framework Core, WebApi создает REST API с документацией Swagger.

Разработаны асинхронные потребители Kafka для обработки событий от основного бота в реальном времени без влияния на его производительность.

Создан REST API с endpoints для получения различных метрик и статистики использования бота, с поддержкой фильтрации по времени и валидацией входных данных.

Обеспечена надежность системы через обработку ошибок, retry-логику и graceful shutdown при завершении работы.

Разработана Docker Compose конфигурация для упрощения развертывания как в dev, так и в production окружении.

Создана comprehensive документация API через Swagger/OpenAPI, облегчающая интеграцию с другими сервисами экосистемы.

*Ключевые характеристики решения*:

Масштабируемость: асинхронная архитектура позволяет обрабатывать растущие объемы данных и пользовательских запросов.

Надежность: потребители Kafka обеспечивают гарантированную доставку сообщений с retry-логикой и обработкой отказов.

Maintainability: Clean Architecture и разделение ответственности облегчают поддержку и расширение функциональности.

Производительность: асинхронные операции и оптимизация запросов обеспечивают высокую пропускную способность системы.

*Возможные направления улучшения*:

Добавление Redis кэша для часто запрашиваемых данных (популярные группы, статистика по дням) сократит нагрузку на базу данных.

Реализация real-time dashboard для визуализации метрик использования бота обеспечит администраторам удобный интерфейс мониторинга.

Добавление ML алгоритмов для предсказания популярных времен использования бота позволит оптимизировать его инфраструктуру.

Расширение аналитики для включения информации об ошибках и проблемах в основном боте улучшит качество обслуживания.

Внедрение мониторинга и алертинга на базе полученных метрик позволит проактивно реагировать на проблемы.

Добавление unit и integration тестов для всех компонентов повысит надежность системы.

Оптимизация производительности через пулинг соединений и батчинг операций ускорит обработку больших объемов данных.

*Область практического применения*:

Разработанный микросервис может использоваться администраторами для мониторинга использования бота, выявления популярных групп, анализа пиковых часов использования и оптимизации работы основного сервиса на основе полученной информации.

Аналогичный подход может быть применен для создания аналитических систем других Telegram-ботов и веб-приложений, требующих сбора и анализа метрик пользовательского поведения.

#pagebreak()
#ch("СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ")
#v(0.8em)
+ Мартин Р. К. Clean Architecture : A Craftsman's Guide to Software Structure and Design / Р. К. Мартин. — Boston : Prentice Hall, 2017. — 432 с.
+ Эванс Э. Domain-Driven Design : Tackling Complexity in the Heart of Software / Э. Эванс. — Boston : Addison-Wesley, 2003. — 529 с.
+ Ньюман С. Building Microservices : Designing Fine-Grained Systems / С. Ньюман. — Boston : O’Reilly Media, 2015. — 280 с.
+ ASP.NET Core documentation [Электронный ресурс]. — URL: https://docs.microsoft.com/en-us/aspnet/core/ (дата обращения: 16.12.2025).
+ Entity Framework Core documentation [Электронный ресурс]. — URL: https://docs.microsoft.com/en-us/ef/core/ (дата обращения: 16.12.2025).
+ Apache Kafka Documentation [Электронный ресурс]. — URL: https://kafka.apache.org/documentation/ (дата обращения: 16.12.2025).
+ MassTransit Documentation [Электронный ресурс]. — URL: https://masstransit.io/ (дата обращения: 16.12.2025).
+ MediatR Documentation [Электронный ресурс]. — URL: https://github.com/jbogard/MediatR (дата обращения: 16.12.2025).
+ PostgreSQL Documentation [Электронный ресурс]. — URL: https://www.postgresql.org/docs/ (дата обращения: 16.12.2025).
+ Docker Documentation [Электронный ресурс]. — URL: https://docs.docker.com/ (дата обращения: 16.12.2025).


#pagebreak()
#{
  show heading: none
  align(heading([ПРИЛОЖЕНИЕ A. Код программы], numbering: none), center)
}

#align([*ПРИЛОЖЕНИЕ A. \ Код программы*], center)
#v(0.8em)

BaseEntity.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Models/Entities/BaseEntity.cs"), lang: "cs", block: true)

UserEntity.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Models/Entities/UserEntity.cs"), lang: "cs", block: true)

RequestEntity.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Models/Entities/RequestEntity.cs"), lang: "cs", block: true)

GroupEntity.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Models/Entities/GroupEntity.cs"), lang: "cs", block: true)

UpdateEntity.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Models/Entities/UpdateEntity.cs"), lang: "cs", block: true)

KafkaOptions.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Models/Options/KafkaOptions.cs"), lang: "cs", block: true)

InvalidDateRangeException.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Models/Exceptions/InvalidDateRangeException.cs"), lang: "cs", block: true)

InvalidParameterException.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Models/Exceptions/InvalidParameterException.cs"), lang: "cs", block: true)

ValidationException.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Models/Exceptions/ValidationException.cs"), lang: "cs", block: true)

IAnalyticsDbContext.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Abstract/IAnalyticsDbContext.cs"), lang: "cs", block: true)

GroupScheduleCommand.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Commands/UserRequests/GroupScheduleCommand.cs"), lang: "cs", block: true)

TeacherScheduleCommand.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Commands/UserRequests/TeacherScheduleCommand.cs"), lang: "cs", block: true)

RoomScheduleCommand.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Commands/UserRequests/RoomScheduleCommand.cs"), lang: "cs", block: true)

SearchCommand.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Commands/UserRequests/SearchCommand.cs"), lang: "cs", block: true)

RegisterUserCommand.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Commands/UserUpdates/RegisterUserCommand.cs"), lang: "cs", block: true)

SubscribeUserToGroupCommand.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Commands/UserUpdates/SubscribeUserToGroupCommand.cs"), lang: "cs", block: true)

SetUserCustomSettingsCommand.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Commands/UserUpdates/SetUserCustomSettingsCommand.cs"), lang: "cs", block: true)

SetUserDefaultSettingsCommand.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Commands/UserUpdates/SetUserDefaultSettingsCommand.cs"), lang: "cs", block: true)

GetRegisteredUsersCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetRegisteredUsersCountQuery.cs"), lang: "cs", block: true)

GetUniqueScheduleViewersCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetUniqueScheduleViewersCountQuery.cs"), lang: "cs", block: true)

GetUniqueGroupScheduleViewersCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetUniqueGroupScheduleViewersCountQuery.cs"), lang: "cs", block: true)

GetUniqueTeacherScheduleViewersCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetUniqueTeacherScheduleViewersCountQuery.cs"), lang: "cs", block: true)

GetUniqueRoomScheduleViewersCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetUniqueRoomScheduleViewersCountQuery.cs"), lang: "cs", block: true)
GetGroupScheduleRequestsCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetGroupScheduleRequestsCountQuery.cs"), lang: "cs", block: true)

GetTopGroupsByRequestsQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetTopGroupsByRequestsQuery.cs"), lang: "cs", block: true)

GetTopGroupsBySubscribersQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetTopGroupsBySubscribersQuery.cs"), lang: "cs", block: true)

GetSearchRequestsCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetSearchRequestsCountQuery.cs"), lang: "cs", block: true)

GetUniqueUsersWhoSearchedCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetUniqueUsersWhoSearchedCountQuery.cs"), lang: "cs", block: true)

GetUsersWithCustomSettingsCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetUsersWithCustomSettingsCountQuery.cs"), lang: "cs", block: true)

GetUsersWhoSetCustomSettingsCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetUsersWhoSetCustomSettingsCountQuery.cs"), lang: "cs", block: true)

GetUsersWithDefaultSettingsCountQuery.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Queries/GetUsersWithDefaultSettingsCountQuery.cs"), lang: "cs", block: true)

DateRangeValidator.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Validators/DateRangeValidator.cs"), lang: "cs", block: true)

NumericParameterValidator.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Validators/NumericParameterValidator.cs"), lang: "cs", block: true)

UserPerformedRequestConsumer.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Kafka/UserPerformedRequestConsumer.cs"), lang: "cs", block: true)

UserUpdatedMessageConsumer.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Application/Kafka/UserUpdatedMessageConsumer.cs"), lang: "cs", block: true)

IAnalyticsReadRepository.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Contracts/IAnalyticsReadRepository.cs"), lang: "cs", block: true)

IAnalyticsWriteRepository.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.Contracts/IAnalyticsWriteRepository.cs"), lang: "cs", block: true)

AnalyticsDbContext.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.DataLayer.EF/Persistence/AnalyticsDbContext.cs"), lang: "cs", block: true)

UserEntityConfiguration.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.DataLayer.EF/Configuration/UserEntityConfiguration.cs"), lang: "cs", block: true)

GroupEntityConfiguration.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.DataLayer.EF/Configuration/GroupEntityConfiguration.cs"), lang: "cs", block: true)

RequestEntityConfiguration.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.DataLayer.EF/Configuration/RequestEntityConfiguration.cs"), lang: "cs", block: true)

UpdateEntityConfiguration.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.DataLayer.EF/Configuration/UpdateEntityConfiguration.cs"), lang: "cs", block: true)

Program.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.WebApi/Program.cs"), lang: "cs", block: true)

StatisticsController.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.WebApi/StatisticsController.cs"), lang: "cs", block: true)

ExceptionHandlingMiddleware.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.WebApi/Middleware/ExceptionHandlingMiddleware.cs"), lang: "cs", block: true)

OpenApiExportMiddleware.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.WebApi/Middleware/OpenApiExportMiddleware.cs"), lang: "cs", block: true)

20251208203602_Initial.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.DataLayer.EF/Migrations/20251208203602_Initial.cs"), lang: "cs", block: true)

20251208203602_Initial.Designer.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.DataLayer.EF/Migrations/20251208203602_Initial.Designer.cs"), lang: "cs", block: true)

20251214195506_AddFKs.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.DataLayer.EF/Migrations/20251214195506_AddFKs.cs"), lang: "cs", block: true)

20251214195506_AddFKs.Designer.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.DataLayer.EF/Migrations/20251214195506_AddFKs.Designer.cs"), lang: "cs", block: true)

AnalyticsDbContextModelSnapshot.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/src/SuaiScheduleBotAnalytics.DataLayer.EF/Migrations/AnalyticsDbContextModelSnapshot.cs"), lang: "cs", block: true)

Program.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/DatabaseSeeder/Program.cs"), lang: "cs", block: true)

UserRequestTypes.cs
#raw(read("../../AI/SuaiScheduleBot/SuaiScheduleBot.Contracts/Constants/UserRequestTypes.cs"), lang: "cs", block: true)

UserUpdateTypes.cs
#raw(read("../../AI/SuaiScheduleBot/SuaiScheduleBot.Contracts/Constants/UserUpdateTypes.cs"), lang: "cs", block: true)

BaseUserMessage.cs
#raw(read("../../AI/SuaiScheduleBot/SuaiScheduleBot.Contracts/Kafka/BaseUserMessage.cs"), lang: "cs", block: true)

IdentifiersSyncMessage.cs
#raw(read("../../AI/SuaiScheduleBot/SuaiScheduleBot.Contracts/Kafka/Messages/IdentifiersSyncMessage.cs"), lang: "cs", block: true)

UserPerformedRequestMessage.cs
#raw(read("../../AI/SuaiScheduleBot/SuaiScheduleBot.Contracts/Kafka/Messages/UserPerformedRequestMessage.cs"), lang: "cs", block: true)

UserUpdatedMessage.cs
#raw(read("../../AI/SuaiScheduleBot/SuaiScheduleBot.Contracts/Kafka/Messages/UserUpdatedMessage.cs"), lang: "cs", block: true)

ExceptionHandlingMiddlewareTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/WebApi/ExceptionHandlingMiddlewareTests.cs"), lang: "cs", block: true)

GetRegisteredUsersCountQueryHandlerTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/QueryHandlers/GetRegisteredUsersCountQueryHandlerTests.cs"), lang: "cs", block: true)

GetGroupScheduleRequestsCountQueryHandlerTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/QueryHandlers/GetGroupScheduleRequestsCountQueryHandlerTests.cs"), lang: "cs", block: true)

GetUniqueScheduleViewersCountQueryHandlerTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/QueryHandlers/GetUniqueScheduleViewersCountQueryHandlerTests.cs"), lang: "cs", block: true)

GetTopGroupsByRequestsQueryHandlerTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/QueryHandlers/GetTopGroupsByRequestsQueryHandlerTests.cs"), lang: "cs", block: true)

GetTopGroupsBySubscribersQueryHandlerTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/QueryHandlers/GetTopGroupsBySubscribersQueryHandlerTests.cs"), lang: "cs", block: true)

ScheduleViewersByTypeQueryHandlerTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/QueryHandlers/ScheduleViewersByTypeQueryHandlerTests.cs"), lang: "cs", block: true)

UserSettingsQueryHandlerTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/QueryHandlers/UserSettingsQueryHandlerTests.cs"), lang: "cs", block: true)

SearchQueryHandlerTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/QueryHandlers/SearchQueryHandlerTests.cs"), lang: "cs", block: true)

QueryValidationTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/QueryHandlers/QueryValidationTests.cs"), lang: "cs", block: true)

DateRangeValidatorTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/Validators/DateRangeValidatorTests.cs"), lang: "cs", block: true)

NumericParameterValidatorTests.cs
#raw(read("../../AI/SuaiScheduleBotAnalytics/tests/SuaiScheduleBotAnalytics.Tests/Application/Validators/NumericParameterValidatorTests.cs"), lang: "cs", block: true)