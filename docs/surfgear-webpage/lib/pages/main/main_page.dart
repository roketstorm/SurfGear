import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:surfgear_webpage/assets/images.dart';
import 'package:surfgear_webpage/components/menu.dart';
import 'package:surfgear_webpage/pages/main/body/main_page_body.dart';
import 'package:surfgear_webpage/pages/main/main_page_footer.dart';
import 'package:surfgear_webpage/pages/main/main_page_header.dart';

import '../../assets/images.dart';
import '../../assets/images.dart';

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
  /// Stream for storing page scroll position
  StreamController _pageOffsetController = StreamController<double>.broadcast();

  /// Page ScrollController
  ScrollController _pageScrollController;

  PageController controller = PageController();
  int index = 0;

  @override
  void initState() {
    super.initState();
    _initScrollControllerListener();
  }

  void _initScrollControllerListener() {
    _pageScrollController = ScrollController()
      ..addListener(
        () {
          var scrollOffset = _pageScrollController.offset;
          _pageOffsetController.add(scrollOffset);
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        // alignment: Alignment.center,
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            layoutBuilder: (current, children) {
              return Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: <Widget>[
                  ...children,
                  if (current != null) current,
                ],
              );
            },
            child: index == 0
                ? Image.asset(
                    imgHeaderBackground,
                    key: Key('1'),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    imgFooterBackground,
                    key: Key('2'),
                    fit: BoxFit.cover,
                  ),
          ),
          Listener(
            onPointerSignal: (signal) {
              if (signal is PointerScrollEvent) {
                if (signal.scrollDelta.dy < 0) {
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
            child: PageView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => index = i),
              children: <Widget>[
                MainPageHeader(),
                MainPageFooter(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Theme(
              data: Theme.of(context).copyWith(brightness: Brightness.dark),
              child: Menu(),
            ),
          ),
        ],
      ),
      // SingleChildScrollView(
      //   scrollDirection: Axis.vertical,
      //   controller: _pageScrollController,
      //   child: GestureDetector(
      //     behavior: HitTestBehavior.opaque,
      //     onVerticalDragStart: (_) {},
      //     child: Stack(
      //       children: [
      //         _buildSurfLogo(),
      //         Column(
      //           children: <Widget>[
      //             ConstrainedBox(
      //               constraints: BoxConstraints.expand(
      //                 height: MediaQuery.of(context).size.height,
      //               ),
      //               child: MainPageHeader(),
      //             ),
      //             StreamBuilder(
      //               stream: _pageOffsetController.stream,
      //               initialData: 0.0,
      //               builder: (context, offset) {
      //                 return MainPageBody(offset.data);
      //               },
      //             ),
      //             ConstrainedBox(
      //               constraints: BoxConstraints.expand(
      //                 height: MediaQuery.of(context).size.height,
      //               ),
      //               child: MainPageFooter(
      //                 scrollChangesStream: _pageOffsetController.stream,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildSurfLogo() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height * 3,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          OverflowBox(
            minWidth: 800,
            maxWidth: double.infinity,
            alignment: Alignment(-0.3, -0.1),
            child: Image.asset(
              imgBackgroundLogo,
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width <= SMALL_SCREEN_WIDTH
                  ? MediaQuery.of(context).size.width
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
