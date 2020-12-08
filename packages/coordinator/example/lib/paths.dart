import 'package:coordinator/coordinator.dart';

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
