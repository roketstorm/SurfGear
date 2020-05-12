import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:surfgear_webpage/assets/text.dart';
import 'package:surfgear_webpage/pages/catalog/catalog_page.dart';
import 'package:surfgear_webpage/pages/main/main_page.dart';
import 'package:surfgear_webpage/style.dart';

void main() {
  runApp(MyApp());
}

abstract class Router {
  static const main = '/';
  static const catalog = '/catalog';

  static final map = <String, Widget>{
    main: MainPage(),
    catalog: CatalogPage(),
  };
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: AppModel(),
      child: ScopedModelDescendant<AppModel>(
        builder: (context, _, model) {
          return MaterialApp(
            title: titleText,
            theme: model.darkMode ? Style.dark : Style.light,
            initialRoute: Router.main,
            onGenerateRoute: (settings) {
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => Router.map[settings.name],
              );
            },
          );
        },
      ),
    );
  }
}

class AppModel extends Model {
  bool _darkMode = false;
  bool get darkMode => _darkMode;
  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void switchTheme() => darkMode = !darkMode;
}
