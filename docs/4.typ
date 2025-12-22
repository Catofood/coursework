#import "lib/gost.typ": *
#import "lib/titlepage.typ": *

#show: doc => init(doc)


= Анализ предметной области
-
= Разработка и анализ требований к программе
-
= Проектирование структуры программы
-
= Разработка и отладка  программы
== REST API эндпоинты
=== Эндпоинт получения количества зарегистрированных пользователей
На рисунке @fig-registered-users-request представлена структура запроса к эндпоинту `/registered-users-count`, который позволяет получить количество пользователей, зарегистрировавшихся за указанный временной промежуток. Эндпоинт принимает опциональные параметры `from` и `to` типа `DateTimeOffset` для определения границ периода анализа.

#figure(
  image("images/registered-users-count-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения количества зарегистрированных пользователей]
) <fig-registered-users-request>

На рисунке @fig-registered-users-response показан пример успешного ответа от эндпоинта с возвращаемым значением типа `integer`, представляющим общее количество зарегистрировавшихся пользователей за заданный период.

#figure(
  image("images/registered-users-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения количества зарегистрированных пользователей]
) <fig-registered-users-response>

\
=== Эндпоинт получения количества уникальных пользователей, просмотревших расписание 
На рисунке @fig-unique-schedule-viewers-request представлена структура запроса к эндпоинту `/unique-schedule-viewers-count`, предназначенному для определения количества уникальных пользователей, которые обращались к любому типу расписания за указанный временной промежуток.

#figure(
  image("images/unique-schedule-viewers-count.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения количества уникальных пользователей, просмотревших расписание]
) <fig-unique-schedule-viewers-request>

На рисунке @fig-unique-schedule-viewers-response показан результат выполнения запроса, содержащий целочисленное значение количества уникальных пользователей, воспользовавшихся функциональностью просмотра расписания.

#figure(
  image("images/unique-schedule-viewers-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения количества уникальных пользователей, просмотревших расписание]
) <fig-unique-schedule-viewers-response>

\
=== Эндпоинт получения количества пользователей, просмотревших расписание аудиторий
На рисунке @fig-unique-room-viewers-request представлена структура запроса к эндпоинту `/unique-room-schedule-viewers-count`, обеспечивающему получение статистики по количеству уникальных пользователей, запрашивавших расписание занятости аудиторий.

#figure(
  image("images/unique-room-schedule-viewers-count-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения количества пользователей, просмотревших расписание аудиторий]
) <fig-unique-room-viewers-request>

На рисунке @fig-unique-room-viewers-response показан пример ответа эндпоинта с числовым значением, отражающим количество уникальных пользователей, обратившихся к расписанию аудиторий за указанный период.

#figure(
  image("images/unique-room-schedule-viewers-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения количества пользователей, просмотревших расписание аудиторий]
) <fig-unique-room-viewers-response>

\
=== Эндпоинт получения количества пользователей, просмотревших расписание групп
На рисунке @fig-unique-group-viewers-request представлена структура запроса к эндпоинту `/unique-group-schedule-viewers-count`, предназначенному для определения количества уникальных пользователей, запрашивавших расписание учебных групп.

#figure(
  image("images/unique-group-schedule-viewers-count-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения количества пользователей, просмотревших расписание групп]
) <fig-unique-group-viewers-request>

На рисунке @fig-unique-group-viewers-response показан результат выполнения запроса, содержащий целочисленное значение количества уникальных пользователей, воспользовавшихся функцией просмотра расписания групп.

#figure(
  image("images/unique-group-schedule-viewers-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения количества пользователей, просмотревших расписание групп]
) <fig-unique-group-viewers-response>

\
=== Эндпоинт получения количества пользователей, просмотревших расписание преподавателей
На рисунке @fig-unique-teacher-viewers-request представлена структура запроса к эндпоинту `/unique-teacher-schedule-viewers-count`, обеспечивающему получение статистики по количеству уникальных пользователей, просматривавших расписание занятий преподавателей.

#figure(
  image("images/unique-teacher-schedule-viewers-count-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения количества пользователей, просмотревших расписание преподавателей]
) <fig-unique-teacher-viewers-request>

На рисунке @fig-unique-teacher-viewers-response показан пример успешного ответа эндпоинта с числовым значением, представляющим количество уникальных пользователей, обратившихся к расписанию преподавателей за заданный временной интервал.

#figure(
  image("images/unique-teacher-schedule-viewers-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения количества пользователей, просмотревших расписание преподавателей]
) <fig-unique-teacher-viewers-response>

\
=== Эндпоинт получения топ групп по количеству подписчиков
На рисунке @fig-top-groups-subscribers-request представлена структура запроса к эндпоинту `/top-groups-by-subscribers`, предназначенному для получения рейтинга наиболее популярных учебных групп по количеству уникальных подписчиков. Эндпоинт принимает параметр `top` для определения размера выборки (от 1 до 100) и опциональный параметр `to` для указания конечной даты анализа.

#figure(
  image("images/top-groups-by-subscribers-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения топ групп по количеству подписчиков]
) <fig-top-groups-subscribers-request>

На рисунке @fig-top-groups-subscribers-response показан пример ответа эндпоинта, содержащий массив объектов с информацией о названии группы и количестве её подписчиков, упорядоченный по убыванию количества подписчиков.

#figure(
  image("images/top-groups-by-subscribers-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения топ групп по количеству подписчиков]
) <fig-top-groups-subscribers-response>

\
=== Эндпоинт получения топ групп по количеству запросов расписания
На рисунке @fig-top-groups-requests-request представлена структура запроса к эндпоинту `/top-groups-by-requests`, обеспечивающему получение рейтинга учебных групп по количеству запросов их расписания за указанный период. Эндпоинт принимает параметр `top` для определения размера выборки и опциональные параметры `from` и `to` для временных границ анализа.

#figure(
  image("images/top-groups-by-requests-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения топ групп по количеству запросов расписания]
) <fig-top-groups-requests-request>

На рисунке @fig-top-groups-requests-response показан результат выполнения запроса, представляющий собой массив объектов с данными о названии группы и количестве запросов её расписания, отсортированный в порядке убывания популярности.

#figure(
  image("images/top-groups-by-requests-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения топ групп по количеству запросов расписания]
) <fig-top-groups-requests-response>

\
=== Эндпоинт получения общего количества запросов расписания групп
На рисунке @fig-group-schedule-count-request представлена структура запроса к эндпоинту `/group-schedule-requests-count`, предназначенному для определения общего количества всех запросов расписания учебных групп за заданный временной промежуток.

#figure(
  image("images/group-schedule-requests-count-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения общего количества запросов расписания групп]
) <fig-group-schedule-count-request>

На рисунке @fig-group-schedule-count-response показан пример ответа эндпоинта с целочисленным значением, отражающим суммарное количество запросов к расписанию групп за указанный период.

#figure(
  image("images/group-schedule-requests-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения общего количества запросов расписания групп]
) <fig-group-schedule-count-response>

\
=== Эндпоинт получения количества пользователей с кастомными настройками
На рисунке @fig-custom-settings-request представлена структура запроса к эндпоинту `/users-with-custom-settings-count`, обеспечивающему получение текущего количества пользователей, использующих персонализированные настройки системы на указанную дату.

#figure(
  image("images/users-with-custom-settings-count-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения количества пользователей с кастомными настройками]
) <fig-custom-settings-request>

На рисунке @fig-custom-settings-response показан результат выполнения запроса, содержащий числовое значение количества пользователей, активно применяющих персонализированные настройки на момент запроса.

#figure(
  image("images/users-with-custom-settings-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения количества пользователей с кастомными настройками]
) <fig-custom-settings-response>

\
=== Эндпоинт получения количества пользователей с настройками по умолчанию
На рисунке @fig-default-settings-request представлена структура запроса к эндпоинту `/users-with-default-settings-count`, предназначенному для определения текущего количества пользователей, использующих стандартные настройки системы.

#figure(
  image("images/users-with-default-settings-count-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения количества пользователей с настройками по умолчанию]
) <fig-default-settings-request>

На рисунке @fig-default-settings-response показан пример ответа эндпоинта с целочисленным значением, отражающим количество пользователей, применяющих стандартную конфигурацию настроек на указанную дату.

#figure(
  image("images/users-with-default-settings-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения количества пользователей с настройками по умолчанию]
) <fig-default-settings-response>

\
=== Эндпоинт получения количества пользователей, изменявших настройки
На рисунке @fig-set-custom-settings-request представлена структура запроса к эндпоинту `/users-who-set-custom-settings-count`, обеспечивающему получение статистики по количеству уникальных пользователей, выполнявших операции по настройке персонализированных параметров системы за указанный временной период.

#figure(
  image("images/users-who-set-custom-settings-count-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения количества пользователей, изменявших настройки]
) <fig-set-custom-settings-request>

На рисунке @fig-set-custom-settings-response показан результат выполнения запроса, содержащий числовое значение количества уникальных пользователей, осуществлявших изменение настроек в заданном временном интервале.

#figure(
  image("images/users-who-set-custom-settings-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения количества пользователей, изменявших настройки]
) <fig-set-custom-settings-response>

\
=== Эндпоинт получения количества пользователей, выполнявших поиск
На рисунке @fig-users-searched-request представлена структура запроса к эндпоинту `/unique-users-who-searched-count`, предназначенному для определения количества уникальных пользователей, использовавших функциональность поиска за указанный временной промежуток.

#figure(
  image("images/unique-users-who-searched-count-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения количества пользователей, выполнявших поиск]
) <fig-users-searched-request>

На рисунке @fig-users-searched-response показан пример ответа эндпоинта с целочисленным значением, представляющим количество уникальных пользователей, обратившихся к поисковой функциональности системы.

#figure(
  image("images/unique-users-who-searched-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения количества пользователей, выполнявших поиск]
) <fig-users-searched-response>

\ 
=== Эндпоинт получения общего количества поисковых запросов
На рисунке @fig-search-count-request представлена структура запроса к эндпоинту `/search-requests-count`, обеспечивающему получение суммарного количества всех поисковых операций, выполненных в системе за заданный период времени.

#figure(
  image("images/search-requests-count-1.png", width: 100%),
  caption: [Структура запроса к эндпоинту получения общего количества поисковых запросов]
) <fig-search-count-request>

На рисунке @fig-search-count-response показан результат выполнения запроса, содержащий числовое значение общего количества поисковых запросов, зарегистрированных системой за указанный временной интервал.

#figure(
  image("images/search-requests-count-2.png", width: 100%),
  caption: [Пример ответа эндпоинта получения общего количества поисковых запросов]
) <fig-search-count-response>
\ 

== Описание данных и структур данных

=== Словарь данных

Словарь данных представляет все основные параметры и переменные, используемые в системе. В таблице @tbl-data-dictionary приведено описание типов данных, доменных значений и ограничений для каждого элемента данных микросервиса.

#figure(
  long-table(
    columns: (1.6fr, 2fr, 2fr, 1.5fr),
    align: (left, left, left, center),
    inset: 6pt,
    [*Поле*], [*Тип*], [*Описание*], [*Ограничения*],
    [TelegramUserId], [long], [Идентификатор пользователя в Telegram], [> 0, уникально],
    [OccuredAt], [DateTimeOffset], [Временная метка события], [не в будущем],
    [GroupName], [string], [Название академической группы], [опционально],
    [RequestType], [enum], [Search, RoomSchedule, GroupSchedule, TeacherSchedule], [не null],
    [UpdateType], [enum], [Registered, SubscribedToGroup, SetDefaultSettings, SetCustomSettings], [не null],
    [SubscriptionGroup
    Name], [string?], [Название подписанной группы], [опционально],
    [From], [DateTimeOffset?], [Начало периода фильтрации], [опционально],
    [To], [DateTimeOffset?], [Конец периода фильтрации], [From <= To],
  ),
  caption: "Словарь данных",
  kind: table
)<tbl-data-dictionary>
\ 
=== Описание файлов и хранилища

*PostgreSQL база данных* содержит следующие таблицы: 

`users` (хранит информацию о пользователях); 

`groups` (хранит информацию о группах); 

`requests` (хранит запросы пользователей); 

`updates` (хранит события обновления); 

`__EFMigrationsHistory` (служебная таблица EF Core для отслеживания миграций).


На рисунке @fig-db-er-diagram показана ER-диаграмма базы данных микросервиса SuaiScheduleBotAnalytics, демонстрирующая основные таблицы и связи между ними.

#figure(
  image("images/db-er-diagram.png", width: 90%),
  caption: [ER-диаграмма базы данных микросервиса SuaiScheduleBotAnalytics],
  kind: image
) <fig-db-er-diagram>

#pagebreak()
=== Основные доменные сущности

В таблице @table-domain-entities представлены основные доменные сущности микросервиса с их свойствами и назначением в системе, включая типы данных и семантику каждого атрибута.

#figure(
  long-table(
    columns: (auto, auto, auto, auto, auto),
    align: (horizon, horizon, left, left, left),
    inset: 6pt,
    [*Сущность*], [*Описание*], [*Свойство*], [*Тип*], [*Комментарий*],
    table.cell(rowspan: 6)[UserEntity],
    table.cell(rowspan: 6)[Представляет пользователя системы],
    [Id], [long], [Первичный ключ, автоинкрементируемое целое число],
    [TelegramId], [long], [Уникальный идентификатор в Telegram],
    [RegisteredAt], [DateTimeOffset], [Дата и время регистрации],
    [FavoriteGroup
    Id], [long?], [ID группы, на которую подписан пользователь],
    [Requests], [List<RequestEntity>], [Навигационное свойство запросов пользователя],
    [Updates], [List<UpdateEntity>], [Навигационное свойство событий обновления пользователя],
    table.cell(rowspan: 5)[GroupEntity],
    table.cell(rowspan: 5)[Представляет академическую группу],
    [Id], [long], [Первичный ключ],
    [Name], [string], [Название группы (например, "М411")],
    [Users], [List<UserEntity>], [Навигационное свойство подписанных пользователей],
    [Requests], [List<RequestEntity>], [Навигационное свойство запросов расписания],
    [Updates], [List<UpdateEntity>], [Навигационное свойство событий обновления группы],
    table.cell(rowspan: 5)[RequestEntity],
    table.cell(rowspan: 5)[Представляет действие пользователя при просмотре расписания],
    [Id], [long], [Первичный ключ],
    [RequestType], [UserRequestTypes], [Тип запроса (enum: ViewSchedule, ViewClassroom и т.д.)],
    [OccuredAt], [DateTimeOffset], [Временная метка события],
    [UserId], [long?], [ID пользователя, выполнившего запрос],
    [GroupId], [long?], [ID группы, по которой выполнен запрос],
    table.cell(rowspan: 5)[UpdateEntity],
    table.cell(rowspan: 5)[Представляет событие обновления информации пользователя],
    [Id], [long], [Первичный ключ],
    [UpdateType], [UserUpdateTypes], [Тип события (enum: Registered, SubscribedToGroup и т.д.)],
    [OccuredAt], [DateTimeOffset], [Временная метка события],
    [UserId], [long?], [ID пользователя],
    [GroupId], [long?], [ID связанной группы],
    table.cell(rowspan: 3)[BaseEntity],
    table.cell(rowspan: 3)[Базовый класс для всех сущностей],
    [Id], [long], [Первичный ключ],
    [CreatedAt], [DateTimeOffset], [Время создания],
    [UpdatedAt], [DateTimeOffset], [Время последнего обновления],
  ),
  caption: "Основные доменные сущности системы",
  kind: table
)<table-domain-entities>
\ 

== Разработка алгоритмов
=== Алгоритм обработки подписки на группу

На рисунке @lst-command-subscribe-algorithm представлена блок-схема алгоритма выполнения команды SubscribeUserToGroupCommand. Алгоритм создаёт группу при отсутствии и сохраняет событие подписки пользователя в базу данных.

#figure(
  image("images/lst-command-subscribe-algorithm.png", height: 70%),
  caption: [Блок-схема алгоритма обработки команды подписки пользователя на группу]
) <lst-command-subscribe-algorithm>
\ 
=== Алгоритм получения статистики зарегистрированных пользователей

На рисунке @lst-query-registered-users-algorithm представлена блок-схема алгоритма обработки запроса GetRegisteredUsersCountQuery. Алгоритм выполняет валидацию временного диапазона, извлекает события регистрации и подсчитывает количество уникальных пользователей, зарегистрировавшихся в заданный период.

#figure(
  image("images/lst-query-registered-users-algorithm.png", height: 70%),
  caption: [Блок-схема алгоритма получения количества зарегистрированных пользователей за период]
) <lst-query-registered-users-algorithm>

=== Алгоритм получения топ N групп по количеству запросов

На рисунке @lst-query-top-groups-requests-algorithm представлена блок-схема алгоритма обработки запроса GetTopGroupsByRequestsQuery. Алгоритм выполняет валидацию входных параметров, извлекает запросы расписания групп за указанный период, группирует их и возвращает рейтинг наиболее часто запрашиваемых групп.

#figure(
  image("images/lst-query-top-groups-requests-algorithm.png", height: 75%),
  caption: [Блок-схема алгоритма получения топ групп по количеству запросов расписания за период]
) <lst-query-top-groups-requests-algorithm>

=== Алгоритм потребления событий запросов пользователей

В листинге @lst-consumer-request-algorithm приведён псевдокод алгоритма асинхронной обработки событий запросов пользователей в потребителе UserPerformedRequestConsumer.

#figure(```SQL
АЛГОРИТМ Потребление событий запросов пользователей
ВХОД: Сообщение из suai.user-performed-request
ВЫХОД: Запись в БД или ошибка

НАЧАЛО
  ПОКА есть сообщение
    Извлечь идентификатор_пользователя, тип_запроса, название_группы
    Найти пользователя; при отсутствии создать и сохранить
    Зафиксировать событие
    ВЫБОР тип_запроса
      Search -> подготовить команду поиска
      RoomSchedule -> подготовить команду расписания аудиторий
      GroupSchedule -> ЕСЛИ указана группа ТО команда расписания группы ИНАЧЕ ошибка отсутствия группы
      TeacherSchedule -> подготовить команду расписания преподавателя
      ИНАЧЕ -> ошибка неизвестного типа
    КОНЕЦ ВЫБОР
    Передать команду в обработчик с повторными попытками
    ЕСЛИ обработка успешна ТО сохранить результат ИНАЧЕ отправить в очередь ошибок
  КОНЕЦ ПОКА
КОНЕЦ
```,
  caption: [Алгоритм асинхронной обработки событий запросов пользователей]
) <lst-consumer-request-algorithm>

=== Алгоритм обработки запроса расписания группы

В листинге @lst-command-group-schedule-algorithm представлен псевдокод алгоритма обработки команды GroupScheduleCommand. Алгоритм сохраняет запрос пользователя и создаёт группу при необходимости.

#figure(```
АЛГОРИТМ Обработка команды запроса расписания группы
ВХОД: Команда с идентификатором пользователя, названием группы и временной меткой
ВЫХОД: Сохранённая в БД запись о запросе

НАЧАЛО
  Проверить наличие пользователя; при отсутствии ошибка "пользователь не найден"
  Найти группу; при отсутствии создать с нормализованным названием и сохранить
  Создать запись запроса расписания группы
  Сохранить запись транзакционно и вывести
КОНЕЦ
```,
  caption: [Алгоритм обработки команды запроса расписания группы]
) <lst-command-group-schedule-algorithm>

=== Алгоритм потребления событий обновлений пользователей

В листинге @lst-consumer-update-algorithm приведён псевдокод алгоритма асинхронной обработки событий об обновлении пользователя в потребителе UserUpdatedMessageConsumer.

#figure(```
АЛГОРИТМ Потребление событий обновлений пользователей
ВХОД: Сообщение из suai.user-updated-message
ВЫХОД: Сохранённые данные в БД и обработанная команда

НАЧАЛО
  ПОКА есть сообщение
    Извлечь идентификатор_пользователя, тип_обновления, название_группы
    Найти пользователя; при отсутствии создать и сохранить
    ВЫБОР тип_обновления
      Registered -> подготовить команду регистрации
      SubscribedToGroup -> ЕСЛИ указана группа ТО команда подписки ИНАЧЕ ошибка отсутствия группы
      SetDefaultSettings -> команда стандартных настроек
      SetCustomSettings -> команда пользовательских настроек
      ИНАЧЕ -> ошибка неизвестного типа
    КОНЕЦ ВЫБОР
    Передать команду в обработчик, сохранить изменения и залогировать событие
  КОНЕЦ ПОКА
КОНЕЦ
```,
  caption: [Алгоритм асинхронной обработки событий обновлений пользователей]
) <lst-consumer-update-algorithm>

=== Алгоритм получения топ групп по уникальным подписчикам

В листинге @lst-query-top-groups-subscribers-algorithm приведён псевдокод алгоритма обработки запроса GetTopGroupsBySubscribersQuery. Алгоритм определяет наиболее популярные группы по количеству уникальных подписчиков.

#figure(```
АЛГОРИТМ Получение топ групп по количеству уникальных подписчиков
ВХОД: Количество групп в топе, дата среза
ВЫХОД: Список групп с количеством подписчиков

НАЧАЛО
  ВВОД top, дата_среза
  ЕСЛИ top < 1 ИЛИ top > 100 ТО ошибка "top вне диапазона"
  ЕСЛИ дата_среза в будущем ТО ошибка "дата в будущем"
  Извлечь события подписки до даты_среза
  Отсортировать по времени, взять последнее событие на пользователя
  Сгруппировать по группе, подсчитать уникальных, отсортировать
  Взять первые top групп и вывести
КОНЕЦ
```,
  caption: [Алгоритм получения топ групп по количеству уникальных подписчиков]
) <lst-query-top-groups-subscribers-algorithm> 

=== Алгоритм получения количества пользователей с настройками

В листинге @lst-query-user-settings-algorithm представлен псевдокод алгоритма обработки запроса GetUsersWithCustomSettingsCountQuery. Алгоритм определяет количество пользователей с кастомными настройками на указанную дату.

#figure(```
АЛГОРИТМ Получение количества пользователей с кастомными настройками
ВХОД: Дата среза
ВЫХОД: Количество пользователей с пользовательскими настройками

НАЧАЛО
  ВВОД дата_среза
  ЕСЛИ дата_среза в будущем ТО ошибка "дата в будущем"
  Извлечь события изменения настроек до даты_среза
  Отсортировать по времени, для каждого пользователя взять последнее событие
  Оставить тип "пользовательские настройки", подсчитать пользователей, вывести
  ПРИМЕЧАНИЕ: для стандартных настроек применить тот же порядок с другим типом события
КОНЕЦ
```,
  caption: [Алгоритм получения количества пользователей с кастомными настройками]
) <lst-query-user-settings-algorithm>

=== Алгоритм валидации параметров запросов

В листинге @lst-validator-date-range-algorithm приведён псевдокод алгоритма валидации диапазона дат в компоненте DateRangeValidator.

#figure(```
АЛГОРИТМ Валидация диапазона дат
ВХОД: Дата начала, дата окончания
ВЫХОД: Ошибка при нарушении правил или успешное завершение

НАЧАЛО
  ВВОД дата_начала, дата_окончания
  ЕСЛИ обе даты заданы И дата_начала > дата_окончания ТО ошибка "некорректный диапазон"
  ЕСЛИ дата_начала задана И дата_начала в будущем ТО ошибка "дата начала в будущем"
  ЕСЛИ дата_окончания задана И дата_окончания в будущем ТО ошибка "дата окончания в будущем"
КОНЕЦ
```,
  caption: [Алгоритм валидации диапазона дат]
) <lst-validator-date-range-algorithm>

В листинге @lst-validator-numeric-algorithm представлен псевдокод алгоритма валидации числовых параметров в компоненте NumericParameterValidator.

#figure(```
АЛГОРИТМ Валидация числовых параметров
ВХОД: Числовое значение, минимально допустимое значение, максимально допустимое значение
ВЫХОД: Ошибка при нарушении границ или успешное завершение

НАЧАЛО
  ВВОД значение, минимум, максимум
  ЕСЛИ значение < минимум ИЛИ значение > максимум ТО ошибка "значение вне диапазона"
КОНЕЦ
```,
  caption: [Алгоритм валидации числовых параметров]
) <lst-validator-numeric-algorithm>

#pagebreak()

== Реализация и отладка программы
#v(1em)
=== Конвенция именования

*Переменные* -- для локальных переменных и параметров используется стиль camelCase (примеры: userId, requestCount, groupName). Для public свойств классов применяется стиль PascalCase (примеры: TelegramId, RegisteredAt, FavoriteGroup). Private поля имеют префикс подчеркивания (примеры: \_logger, \_mediator, \_dbContext).

*Функции и методы* -- все публичные методы именуются в стиле PascalCase с глаголами в названии, такими как Get, Set, Create, Update, Delete, Process (примеры: GetRegisteredUsersCount(), Consume()).

*Классы и типы* -- все классы, интерфейсы и перечисления используют стиль PascalCase. Доменные модели имеют суффикс Entity (примеры: UserEntity, GroupEntity). Kafka потребители имеют суффикс Consumer (примеры: UserPerformedRequestConsumer). MediatR объекты имеют суффиксы Query, Command, Handler. REST контроллеры имеют суффикс Controller. Интерфейсы имеют префикс I (пример: IAnalyticsDbContext).

*Модули и пространства имен* -- структурированы по архитектурным слоям (Application, Domain, Infrastructure) с дополнительными папками для группировки логики (Kafka, Commands, Queries, Persistence).

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
    columns: (1.2fr, 1fr, 2fr, 1.5fr, 1.2fr, 1.25fr),
    align: (left, left, left, left, left, left),
    inset: 6pt,
    [*Класс*], [*Имя\ метода,\ функции*], [*Прототип*], [*Назначение*], [*Входные данные*], [*Выходные данные*],
    [User
    Performed
    Request
    Consumer], [Consume], [Task Consume
    (ConsumeContext
    \<UserPerformed
    RequestMessage\> context)], [Обработка события просмотра расписания из Kafka и сохранение в БД], [context], [-],
    [Get
    Registered
    Users
    Count
    Query
    Handler], [Handle], [Task\<int\> Handle
    (GetRegistered
    UsersCountQuery query,
    CancellationToken
    cancellationToken)], [Получение количества зарегистрировавшихся пользователей за период с валидацией диапазона дат], [query, cancellation
    Token], [int],
    [GetGroup
    Schedule
    Requests
    Count
    Query
    Handler], [Handle], [Task\<int\> Handle
    (GetGroup
    Schedule
    RequestsCount
    Query query,
    CancellationToken
    cancellationToken)], [Получение количества запросов на просмотр расписания групп за период], [query, cancellation
    Token], [int],
    [Register
    User
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
    [Search
    Request
    Handler], [Handle], [Task Handle
    (SearchCommand
    command,
    CancellationToken
    cancellationToken)], [Добавление записи о поисковом запросе пользователя в БД], [command, cancellation
    Token], [-],
    [Room
    Schedule
    Command
    Handler], [Handle], [Task Handle
    (RoomSchedule
    Command command,
    CancellationToken
    cancellationToken)], [Добавление записи о запросе расписания аудитории в БД], [command, cancellation
    Token], [-],
    [Teacher
    Schedule
    Command
    Handler], [Handle], [Task Handle
    (TeacherSchedule
    Command command,
    CancellationToken
    cancellationToken)], [Добавление записи о запросе расписания преподавателя в БД], [command, cancellation
    Token], [-],
    [Subscribe
    User
    ToGroup
    Command
    Handler], [Handle], [Task Handle
    (SubscribeUser
    ToGroup
    Command command,
    CancellationToken
    cancellationToken)], [Создание записи события подписки пользователя на группу с созданием группы при необходимости], [command, cancellation
    Token], [-],
    [SetUser
    Custom
    Settings
    Command
    Handler], [Handle], [Task Handle
    (SetUserCustom
    SettingsCommand
    command,
    CancellationToken
    cancellationToken)], [Создание записи события установки пользовательских настроек], [command, cancellation
    Token], [-],
    [GetTop
    GroupsBy
    Subscribers
    Query
    Handler], [Handle], [Task\<List\<Group
    AndSubscribers
    ResponseModel\>\>
    Handle
    (GetTopGroupsBy
    SubscribersQuery
    query,
    CancellationToken
    cancellationToken)], [Получение топ N групп по количеству уникальных подписчиков с валидацией параметров], [query, cancellation
    Token], [List\<Group
    And
    Subscribers
    Response
    Model\>],
    [GetTop
    Groups
    By
    Requests
    Query
    Handler], [Handle], [Task\<List\<Top
    Group
    ByRequests
    ResponseModel\>\> Handle
    (GetTopGroupsBy
    RequestsQuery query,
    CancellationToken
    cancellationToken)], [Получение топ N групп по количеству запросов расписания с валидацией диапазона дат], [query, cancellation
    Token], [List\<Top
    Group
    ByRequests
    Response
    Model\>],
    [Get
    Unique
    Schedule
    Viewers
    Count
    Query
    Handler], [Handle], [Task\<int\> Handle
    (GetUnique
    ScheduleViewers
    CountQuery query,
    CancellationToken
    cancellationToken)], [Получение количества уникальных пользователей, просмотревших расписание (любого типа) за период], [query, cancellation
    Token], [int],
    [Date
    Range
    Validator], [Validate
    Date
    Range], [void ValidateDateRange
    (DateTimeOffset? from,
    DateTimeOffset? to)], [Валидация корректности диапазона дат (from не позже to)], [from, to], [-],
    [Date
    Range
    Validator], [Validate
    Not
    Future], [void ValidateNotFuture
    (DateTimeOffset? date,
    string parameterName)], [Валидация что дата не находится в будущем], [date, parameter
    Name], [-],
    [Numeric
    Parameter
    Validator], [Validate
    Positive
    Integer], [void ValidatePositive
    Integer
    (int value,
    string parameterName,
    int minValue,
    int maxValue)], [Валидация что числовой параметр находится в допустимом диапазоне], [value, parameter
    Name, minValue, maxValue], [-],
  ),
  caption: "Описание основных функций и методов",
  kind: table
)<tbl-functions>

=== Оптимизация кода

*Оптимизация производительности* достигается использованием асинхронных операций (async/await) для non-blocking I/O, query splitting в Entity Framework Core для оптимизации запросов с Include(), использованием индексов на часто используемых полях (UserId, GroupId, OccuredAt), кэшированием результатов часто запрашиваемых данных.

*Оптимизация объема кода* включает использование DI контейнера для избежания дублирования логики, применение паттерна медиатор для уменьшения связанности компонентов, использование интерфейсов для абстрагирования реализации.

*Масштабируемость системы* обеспечивается микросервисной архитектурой, которая позволяет масштабировать компоненты независимо. Асинхронная обработка через Kafka позволяет обрабатывать пиковые нагрузки без перегруженности. Stateless дизайн API позволяет горизонтальное масштабирование приложения.

=== Средства отладки

Для отладки приложения используются следующие инструменты: Jetbrains Rider для интерактивной отладки приложения с breakpoints и пошаговым выполнением, Jetbrains DataGrip для просмотра и анализа данных в PostgreSQL, Kafka UI для мониторинга топиков Kafka и анализа сообщений в очередях, Application Insights для мониторинга production приложения и сбора телеметрии, structured logging с Serilog для структурированного анализа логов и отслеживания проблем, Swagger UI для тестирования REST API endpoints и проверки контрактов.
