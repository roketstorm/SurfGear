# Coordinator

## About
Координатор это библиотека, которая упрощает работу с Navigator API 2.0

## Currently supported features

- Декларативная настройка роутов из одного места
- Подключение стороней бизнеслогики для реализации условий роутов
- Получение текущего роута ниже по контексту
- Парсер роутов для настройки навигации для веб страниц
- Тестируемость навигации

## Usage

Чтобы начать использовать Coordinator, создайте приложение через конструктор MaterialApp.router.

```dart
class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: CoordinatorDelegate(
          initialRoute: HomePath(),
          calculateRoute: (routeHistory) {
            var pageList = <Page>[];
            for (var route in routeHistory) {
              if (route is HomePath)
                pageList.add(MaterialPage(
                  child: HomePage(),
                ));
              if (route is UserListPath)
                pageList.add(MaterialPage(
                  child: UserListPage(),
                ));
              if (route is UserDetailsPath)
                pageList.add(MaterialPage(
                  child: UserDetailsPage(userId: route.userId),
                ));
            }
            return pageList;
          }),
      routeInformationParser: DefaultRouteParser(),
      // routeInformationParser: MyRouteParser(),
    );
  }
}
```

В параметр `routerDelegate` подключите `CoordinatorDelegate`
CoordinatorDelegate содержит параметры:
- `initialRoute` - начальный роут
- `calculateRoute` - функция, передающая историю роутов, на основе которой можно сконфигурировать 
переходы на страницы по необходимым условиям. Последний роут в списке 
будет на верху навигации. При выполнении действия `pop()` у навигатора, посдений роут удаляется из списка
и происходит откат до последнего роута без пересодздания страницы. К этой фунции так-же можно подключить
стороннюю бизнеслогику и навесить дополнительных условий для роутов.
- `routeInformationParser` - парсер поисковой строки. Подробнее ниже.

Для конфигурации роутов используются наследники класса `BasePath`.
Этот класс содержит имя роута, и может содержать необходимые данные для перехода.

```dart
class BasePath {
  final String currentRoute;

  BasePath(this.currentRoute);
}

class HomePath extends BasePath {
  HomePath() : super('home');
}

class UserListPath extends BasePath {
  UserListPath() : super('userList');
}

class UserDetailsPath extends BasePath {
  final int userId;

  UserDetailsPath({this.userId}) : super('userDetails');
}
```

Для перехода на другую страницу, получите навигатор ниже по контексту
и вызовите метод `setNewRoutePath(BasePath path)`

```dart
var router = Router.of(context).routerDelegate;
Button(onTap: () => router.setNewRoutePath(UserDetailsPath(userId: userId)));
```

Для получения текущего роута ниже по контексту используйте `currentConfiguration`
```dart
var router = Router.of(context).routerDelegate;
router.currentConfiguration
```

### Парсинг строки роутов
Парсер поисковой строки используется для поисковой веб строки либо для реализации диплинков.
По умолчанию стоит стандартный парсер, который просто возвращает наименование текущего роута

```dart
class DefaultRouteParser extends RouteInformationParser<BasePath> {
  @override
  Future<BasePath> parseRouteInformation(
          RouteInformation routeInformation) async =>
      BasePath(currentRoute: routeInformation.location);

  @override
  RouteInformation restoreRouteInformation(BasePath path) =>
      RouteInformation(location: path.currentRoute);
}
```

- parseRouteInformation - возвращает текущий роут, исходя из строки/диплинка
- restoreRouteInformation - возвращает строку для веба/диплинка, исходя из текущего роута

Но при желании можно настроить необходимый парсинг строк

```dart
class MyRouteParser extends RouteInformationParser<BasePath> {
  @override
  Future<BasePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    print(uri);
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return BasePath.home();
    }

    // Handle base paths
    if (uri.pathSegments.length == 1) {
      var basePath = uri.pathSegments[0];
      if (basePath == 'userList') {
        return BasePath.userList();
      }
      if (basePath == 'bookList') {
        return BasePath.booksList();
      }
    }

    // handle details paths
    if (uri.pathSegments.length == 2) {
      var basePath = uri.pathSegments[0];
      //parse /userList/:userId
      if (basePath == 'userList') {
        var userId = int.tryParse(uri.pathSegments[1]);
        return UserDetailsPath(userId: userId);
      }
      //parse /booksList/:bookName
      if (basePath == 'bookList') {
        var bookName = uri.pathSegments[1];
        return BookDetailsPath(bookName: bookName);
      }
    }

    // Handle unknown routes
    return BasePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(BasePath path) {
    var currentRoute = path.currentRoute;
    if (currentRoute == CurrentRoute.home) {
      return RouteInformation(location: '/');
    }

    if (currentRoute == CurrentRoute.unknown) {
      return RouteInformation(location: '/404');
    }

    if (currentRoute == CurrentRoute.userList) {
      return RouteInformation(location: '/userList');
    }

    if (currentRoute == CurrentRoute.userDetails) {
      var userDetailsPath = path as UserDetailsPath;
      return RouteInformation(location: '/userList/${userDetailsPath.userId}');
    }

    if (currentRoute == CurrentRoute.booksList) {
      return RouteInformation(location: '/bookList');
    }

    if (currentRoute == CurrentRoute.booksDetails) {
      var bookDetailsPath = path as BookDetailsPath;
      return RouteInformation(location: '/bookList/${bookDetailsPath.bookName}');
    }

    return null;
  }
}
```

### Тестирование
Благодаря тому, что расчет роутов происходит в функции `calculateRoute`, которая принимает на вход
историю роутов, а возвращает список роутов, навигацию можно протестировать

```dart
  testWidgets('Тестирование навигации', (tester) {
    final delegate = CoordinatorDelegate(calculateRoute: (history) {
      var pageList = <Page>[];
      for (var route in history) {
        if (route is HomePath)
          pageList.add(
            MaterialPage(
              child: HomePage(),
            ),
          );
      }
      return pageList;
    });


    final homePath = HomePath();
    delegate.setNewRoutePath(homePath);
    /// тест на соответствие роута
    expect(homePath, delegate.currentConfiguration);
    
    /// тест на соответствие страницы по роуту
    expect(MaterialPage, delegate.calculateRoute(delegate.routeHistory).last.runtimeType);
  });
```
## Changelog

## Issues

## Contribute
If you would like to contribute to the package (such as by improving the documentation, solving a bug, or adding a cool new feature), please address our [contribution guide](../../CONTRIBUTING.md) first and send us your pull request.

Your help is always appreciated.
## How to reach us

Please, feel free to ask any questions about this package. Join our community chat on Telegram. We speak English and Russian.

[![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/SurfGear)

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)

