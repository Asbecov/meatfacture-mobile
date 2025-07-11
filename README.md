# Мясофактура

flutter version 3.7.9, но работает без null safety

## Акции:

Я в Магазине App\\Models\\ClientPromotion
Любимый продукт App\\Models\\ClientActivePromoFavoriteAssortment
Желтые ценник App\\Models\\PromoYellowPrice
Разнообразное питание App\\Models\\PromoDiverseFoodClientDiscount
Зеленые ценники App\\Models\\PromoDescription

## Статусы заказов (order_status_id):

new Оформлен
collecting Собирается
collected Собран
delivering Доставляется
done Выполнен
cancelled Отменен


dart run flutter_launcher_icons

## Реализация тестового: 
Основной код экрана описан в 

[Данном файле](/lib/pages/recomendations_page.dart)


Для реализации использовал уже имеющиеся в проекте зависимости, такие как: 
- **RecomendationBloc**, который подтягивает необходимые рекомендации с удаленного сервера
- **BasketProvider** и **BasketListBloc** для работы с корзиной покупок.

### Адаптивность и соотвествие дизайну
Верстка получилась адаптивная и придерживающаяся данных изначально дизайн паттернов приложения, при написании кода использовал все принципы форматирования и написания красивого и поддержимаевого UI кода.

### Скриншоты
![!image](res/photo_2025-07-11_22-47-04.jpg)
![!image](res/photo_2025-07-11_22-47-27.jpg)
![!image](res/photo_2025-07-11_22-47-30.jpg)

### Видео
![!gif](res/video_2025-07-11_22-51-43.gif)