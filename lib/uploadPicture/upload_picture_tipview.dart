import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterappdemo/resources/base_style.dart';
import 'package:toggle_rotate/toggle_rotate.dart';

class WidgetNodePanel extends StatefulWidget {
  final String text;
  final Widget show;

  WidgetNodePanel({this.text, this.show});

  @override
  _WidgetNodePanelState createState() => _WidgetNodePanelState();
}

class _WidgetNodePanelState extends State<WidgetNodePanel> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  bool get isFirst => _crossFadeState == CrossFadeState.showFirst;

  Color get themeColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          buildNodeTitle(),
          SizedBox(
            height: 5,
          ),
          Divider(),
          _buildCode(context),
        ],
      ),
    );
  }

  Widget buildNodeTitle() => Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // child: Circle(
            //   color: themeColor,
            //   radius: 5,
            // ),
          ),
          Expanded(
            child: Text(
              '${widget.text}',
              style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: BColors.black,
                  fontSize: 12),
            ),
          ),
          _buildCodeButton()
        ],
      );

  Widget _buildCodeButton() => Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: ToggleRotate(
          durationMs: 300,
          rad: pi,
          child: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
          ),
          onTap: _toggleCodePanel,
        ),
      );

  Widget _buildCode(BuildContext context) => AnimatedCrossFade(
        firstCurve: Curves.easeInCirc,
        secondCurve: Curves.easeInToLinear,
        firstChild: Container(),
        secondChild: Container(
          width: MediaQuery.of(context).size.width,
          child: widget.show,
        ),
        duration: Duration(milliseconds: 200),
        crossFadeState: _crossFadeState,
      );

  // 折叠代码面板
  _toggleCodePanel() {
    setState(() {
      _crossFadeState =
          !isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond;
    });
  }
}
