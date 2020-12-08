import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coordinator/coordinator.dart';

class HomePath extends BasePath {
  HomePath() : super('home');
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ignore: missing_return
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

    /// тест на соответствие страници по роуту
    expect(MaterialPage, delegate.calculateRoute(delegate.routeHistory).last.runtimeType);
  });
}
