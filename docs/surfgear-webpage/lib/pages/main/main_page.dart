import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:surfgear_webpage/assets/images.dart';
import 'package:surfgear_webpage/assets/text.dart';
import 'package:surfgear_webpage/common/uikit.dart';
import 'package:surfgear_webpage/components/menu.dart';
import 'package:surfgear_webpage/main.dart';

/// Medium screen width
const double MEDIUM_SCREEN_WIDTH = 1500;

/// Small screen width
const double SMALL_SCREEN_WIDTH = 800;

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  PageController controller = PageController();
  int index = 0;

  Widget _getBackground(int index) {
    final theme = Theme.of(context);

    if (index == 0) {
      return Transform.translate(
        offset: Offset(0, -16.0),
        child: Image.network(
          '/$assetsRoot/$svgSurfLogo',
          key: Key('0'),
          color: theme.brightness == Brightness.dark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
          fit: BoxFit.cover,
        ),
      );
    }

    if (index == 1) {
      return Align(
        alignment: Alignment(0.0, 0.4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Image.network(
            '/$assetsRoot/$svgCompanies',
            key: Key('1'),
            color: theme.accentColor,
          ),
        ),
      );
    }

    if (index == 2) {
      return SizedBox.shrink(
        key: Key('2'),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _switcherLayoutBuilder(Widget current, List<Widget> children) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        ...children,
        if (current != null) current,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            layoutBuilder: _switcherLayoutBuilder,
            child: _getBackground(index),
          ),
          Listener(
            onPointerSignal: (signal) {
              if (signal is PointerScrollEvent) {
                if (signal.scrollDelta.dy < 0 || signal.scrollDelta.dx < 0) {
                  controller.previousPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                }
              }
            },
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is OverscrollIndicatorNotification) {
                  notification.disallowGlow();
                }
                return false;
              },
              child: PageView(
                controller: controller,
                onPageChanged: (i) => setState(() => index = i),
                children: <Widget>[
                  _HelloSlide(),
                  _ProductionSlide(),
                  _ToCatalogSlide(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Menu(),
          ),
          Align(
            alignment: Alignment(0.0, 0.9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 40.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: SlideEffect(
                      activeDotColor: Theme.of(context).accentColor,
                      spacing: 16.0,
                      paintStyle: PaintingStyle.stroke,
                      dotColor: Theme.of(context).accentColor.withOpacity(0.6),
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.brightness_medium),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    ScopedModel.of<AppModel>(context).switchTheme();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HelloSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 56.0,
          vertical: 32.0,
        ),
        child: Image.network(
          '/$assetsRoot/$svgSurfgearLogo',
          color: Theme.of(context).accentColor,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 56.0,
          vertical: 32.0,
        ),
        child: Text(
          'Плагины для Flutter-проектов',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    ];

    if (MediaQuery.of(context).size.width > MEDIUM_SCREEN_WIDTH) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }
  }
}

class _ProductionSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, -0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Text(
          'Эссенция опыта спустя годы работы, всё здесь',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}

class _ToCatalogSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Text(
            'Каталог модулей, для вас',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        SizedBox(height: 32.0),
        FilledButton(
          title: mainPageCatalogBtnText,
          onPressed: () => Navigator.of(context).pushNamed(Router.catalog),
        ),
      ],
    );
  }
}
