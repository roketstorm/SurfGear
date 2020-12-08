import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  final int userId;

  UserDetailsPage({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Деталка юзера $userId",
              style: Theme.of(context).textTheme.headline3,
            )
          ],
        ),
      ),
    );
  }
}
