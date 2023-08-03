# NewsApp

![Alt Text](https://github.com/ivanMoskalevDev/NewsApp/blob/main/NewsApp/Resources/preview.gif)

RU: 

Пожалуйста по возможности используйте свой API ключ, так как количество запросов ограничено. 
Для этого в файле NewsRequestServices.swift в константу ApiKey введите свой API ключ.

GUI верстается из кода с помощью UIKit. 

Автолейауты реализованы с помощью библиотеки SnapKit.

Приложения отправляет запрос на сервер newsapi.org, получает список новостей в разных категориях и отображает его в UI.

Запросы в сеть реализованы через библиотеку URLSession.

Отображение новостей реализовано с помощью UITableView.

Архитектура приложения: MVVM.

Реализовано изменение темы приложения и сохранение состояния темы в локальную память с помощью UserDefaults.

При нажатии на плитку с новостью приложение предлагает переход в браузер для получения подробнной информации о новости.

Планы:
1. Реализация экрана избранное
2. Добавление новостей в "Избранное"
3. Сохранение избранных новостей в память смартфона.


EN: 

Please use your API key whenever possible, as the number of requests is limited. 
To do this, in the NewsRequestServices.swift file, enter your API key into the ApiKey constant.

GUI is made up from code using UIKit.

Autolayouts are implemented using the SnapKit library.

The application sends a request to the server newsapi.org , gets a list of news in different categories and displays it in the UI.

Requests to the network are implemented through the URLSession library.

News display is implemented using UITableView.

Application architecture: MVVM.

Implemented changing the application theme and saving the theme state to local memory using UserDefaults.

When you click on the tile with the news, the application offers a transition to the browser to get detailed information about the news.

Plans:
1. Implementation of the favorites screen
2. Adding news to Favorites
3. Save your favorite news to your smartphone's memory.
