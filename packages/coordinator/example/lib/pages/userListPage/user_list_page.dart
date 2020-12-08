import 'package:coordinator_example/paths.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  var users = {
    "User 1": 1,
    "User 2": 2,
    "User 3": 3,
    "User 4": 4,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Юзеры",
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              height: 32,
            ),
            for (String user in users.keys)
              _buildUserItem(
                context,
                user,
                users[user],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem(
    BuildContext context,
    String userName,
    int userId,
  ) {
    var router = Router.of(context).routerDelegate;
    print(router.currentConfiguration);
    return InkWell(
      onTap: () => router.setNewRoutePath(UserDetailsPath(userId: userId)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            userName,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }
}
