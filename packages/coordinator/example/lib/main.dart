import 'package:coordinator/coordinator.dart';
import 'package:coordinator_example/pages/homePage/home_page.dart';
import 'package:coordinator_example/pages/userDetailsPage/user_details_page.dart';
import 'package:coordinator_example/pages/userListPage/user_list_page.dart';
import 'package:coordinator_example/paths.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

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
