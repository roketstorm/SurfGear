import 'package:coordinator/base_path.dart';
import 'package:flutter/material.dart';

class DefaultRouteParser extends RouteInformationParser<BasePath> {
  @override
  Future<BasePath> parseRouteInformation(
          RouteInformation routeInformation) async =>
      BasePath(routeInformation.location);

  @override
  RouteInformation restoreRouteInformation(BasePath path) =>
      RouteInformation(location: path.currentRoute);
}
