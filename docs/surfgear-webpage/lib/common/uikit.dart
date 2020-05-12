import 'package:flutter/material.dart';
import 'package:surfgear_webpage/common/widgets.dart';

class FilledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  FilledButton({
    Key key,
    @required this.onPressed,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WebButton(
      onPressed: onPressed,
      buttonBuilder: (context, isHovering) {
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.accentColor),
            color: isHovering ? theme.accentColor : theme.buttonColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 40.0,
            ),
            child: Text(
              title,
              style: theme.textTheme.button.copyWith(
                color: isHovering ? theme.primaryColor : theme.accentColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
