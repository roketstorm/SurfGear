import 'package:coordinator/base_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef List<Page> CalculateRoute(List<BasePath> path);

class CoordinatorDelegate extends RouterDelegate<BasePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BasePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final CalculateRoute calculateRoute;

  final List<BasePath> routeHistory = [];

  @override
  BasePath get currentConfiguration => routeHistory.last;

  CoordinatorDelegate({
    @required this.calculateRoute,
    BasePath initialRoute,
  }) {
    if (initialRoute != null) {
      routeHistory.add(initialRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: calculateRoute(routeHistory),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _clearLastPath();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BasePath path) async {
    _addNewPath(path);
  }

  void _clearLastPath() {
    routeHistory.removeLast();
    notifyListeners();
  }

  void _addNewPath(BasePath path) {
    routeHistory.add(path);
    notifyListeners();
  }
}
